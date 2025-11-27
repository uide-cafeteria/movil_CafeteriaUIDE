import 'package:flutter/material.dart';
import '../../models/daily_menu.dart';
import '../../services/cafeteria_services.dart';
import '../../config/app_theme.dart';
import '../layout/widgets/dish_card.dart';
import '../layout/widgets/promotion_card.dart';
import '../layout/widgets/day_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CafeteriaService _service = CafeteriaService();
  late DayOfWeek _selectedDay;
  late DailyMenu _currentMenu;

  // Simulación de estado de autenticación (puedes conectar con Firebase, SecureStorage, etc.)
  bool _isLoggedIn = false;
  String _userName = "Invitado";

  @override
void initState() {
  super.initState();
  _selectedDay = DateTime.now().toDayOfWeek();
  _loadMenu();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final modalRoute = ModalRoute.of(context);
    if (modalRoute?.settings.arguments is Map) {
      final args = modalRoute!.settings.arguments as Map;
      if (args.containsKey('userName')) {
        setState(() {
          _isLoggedIn = true;
          _userName = args['userName'];
        });
      }
    }
  });
}

  void _loadMenu() {
    setState(() {
      _currentMenu = _service.getMenuForDay(_selectedDay);
    });
  }

  void _onDayChanged(DayOfWeek day) {
    setState(() {
      _selectedDay = day;
      _loadMenu();
    });
  }

  // 1. Reemplaza todo _showLoginDialog() por esto:
void _showLoginDialog() {
  Navigator.pushNamed(context, '/login');
}

  void _logout() {
  setState(() {
    _isLoggedIn = false;
    _userName = "Invitado";
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Sesión cerrada"),
      backgroundColor: Colors.green,
    ),
  );

  // Redirige al login y elimina todo el historial (no puede volver atrás)
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/login',  // Asegúrate de tener esta ruta definida
    (route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    final promotions = _service.getActivePromotions();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              pinned: false,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cafetería Universitaria',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      // Menú de usuario
                      PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        offset: const Offset(0, 50),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                          child: Icon(
                            _isLoggedIn ? Icons.person : Icons.person_outline,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'profile') {
                          // Navigator.pushNamed(context, '/profile');
                          } else if (value == 'login') {
                            _showLoginDialog();
                          } else if (value == 'logout') {
                            _logout(); // Esta línea se queda igual, PERO ahora _logout() ya redirige al login
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.person, color: Colors.grey[700]),
                                const SizedBox(width: 12),
                                Text(_isLoggedIn ? _userName : "Invitado"),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          if (!_isLoggedIn)
                            PopupMenuItem(
                              value: 'login',
                              child: Row(
                                children: [
                                  Icon(Icons.login, color: AppTheme.primaryColor),
                                  const SizedBox(width: 12),
                                  const Text("Iniciar Sesión"),
                                ],
                              ),
                            )
                          else
                            PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  const Icon(Icons.logout, color: Colors.red),
                                  const SizedBox(width: 12),
                                  const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          // Puedes añadir más opciones aquí:
                          // PopupMenuItem(value: 'reservations', child: Text("Mis Reservas")),
                          // PopupMenuItem(value: 'history', child: Text("Historial")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // === Resto de tu contenido actual (sin cambios) ===
            if (promotions.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          size: 18,
                          color: AppTheme.accentColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Ofertas del día',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 140,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: promotions.length,
                    itemBuilder: (context, index) {
                      return PromotionCard(promotion: promotions[index]);
                    },
                  ),
                ),
              ),
            ],

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menú semanal',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    DaySelector(
                      selectedDay: _selectedDay,
                      onDaySelected: _onDayChanged,
                    ),
                  ],
                ),
              ),
            ),

            if (_currentMenu.dishes.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.no_meals_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Sin servicio este día', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text('Selecciona otro día para ver el menú', style: TextStyle(color: Colors.grey[400])),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: DishCard(dish: _currentMenu.dishes[index]),
                      );
                    },
                    childCount: _currentMenu.dishes.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }
}