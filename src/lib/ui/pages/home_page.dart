import 'package:cafeteria_uide/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import '../../models/daily_menu.dart';
import '../../services/cafeteria_services.dart';
import '../../services/producto_service.dart';
import '../../models/producto.dart';
import '../../config/app_theme.dart';
import '../layout/widgets/dish_card.dart';
import '../layout/widgets/promotion_card.dart';
import '../layout/widgets/day_selector.dart';
import './catering_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CafeteriaService _service = CafeteriaService();
  final ProductoService _productoService = ProductoService(); // NUEVO
  late DayOfWeek _selectedDay;
  late DailyMenu _currentMenu;

  bool _isLoggedIn = false;
  String _userName = "Invitado";
  bool _isLoadingUser = true;

  // Para los productos
  late Future<List<Producto>> _futureProductos;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().toDayOfWeek();
    _loadMenu();
    _loadUserData();
    _futureProductos = _productoService
        .obtenerProductos(); // CARGAMOS PRODUCTOS
  }

  Future<void> _loadUserData() async {
    final token = await SecureStorage.getToken();
    final name = await SecureStorage.getUserName();

    if (token != null && name != null) {
      setState(() {
        _isLoggedIn = true;
        _userName = name;
        _isLoadingUser = false;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        _userName = "Invitado";
        _isLoadingUser = false;
      });
    }
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

  void _showLoginDialog() {
    Navigator.pushNamed(context, '/login');
  }

  void _logout() async {
    await SecureStorage.clearAll();
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

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final promotions = _service.getActivePromotions();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar con saludo y menú de usuario
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
                            _isLoadingUser
                                ? 'Cargando...'
                                : _isLoggedIn
                                ? _userName
                                : 'Cafetería Universitaria',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        offset: const Offset(0, 50),
                        child: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(
                            0.15,
                          ),
                          radius: 22,
                          child: Icon(
                            _isLoggedIn ? Icons.person : Icons.person_outline,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'login') _showLoginDialog();
                          if (value == 'logout') _logout();
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
                          _isLoggedIn
                              ? PopupMenuItem(
                                  value: 'logout',
                                  child: Row(
                                    children: const [
                                      Icon(Icons.logout, color: Colors.red),
                                      SizedBox(width: 12),
                                      Text(
                                        "Cerrar Sesión",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                )
                              : PopupMenuItem(
                                  value: 'login',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.login,
                                        color: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text("Iniciar Sesión"),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // === SERVICIO DE CATERING ===
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CateringPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.9),
                          AppTheme.primaryColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.event_available,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Servicio de Catering',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Reservas para eventos académicos y sociales',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // === OFERTAS DEL DÍA ===
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
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
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
                    itemBuilder: (context, index) =>
                        PromotionCard(promotion: promotions[index]),
                  ),
                ),
              ),
            ],

            // Sección de prueba para mostrar los productos desde backend
            //Usado meramente para probar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: AppTheme.primaryColor,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Nuestros Platos',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            FutureBuilder<List<Producto>>(
              future: _futureProductos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                          Text("Error al cargar productos"),
                          TextButton(
                            onPressed: () => setState(
                              () => _futureProductos = _productoService
                                  .obtenerProductos(),
                            ),
                            child: Text("Reintentar"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final productos = snapshot.data ?? [];

                if (productos.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "No hay productos disponibles",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final p = productos[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: p.imagen.isNotEmpty
                                  ? Image.network(
                                      p.imagen,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.restaurant,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.restaurant),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p.descripcion,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "\$${p.precio.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: productos.length),
                  ),
                );
              },
            ),

            // === MENÚ SEMANAL (tu código original) ===
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menú semanal',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
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

            // ... resto del menú semanal (sin cambios)
            if (_currentMenu.dishes.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.no_meals_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sin servicio este día',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selecciona otro día para ver el menú',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      ),
                      child: DishCard(dish: _currentMenu.dishes[index]),
                    ),
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
