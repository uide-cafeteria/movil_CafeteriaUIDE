// Servicio para gestionar datos de la cafetería
// Aquí puedes conectar con Firebase, API REST, etc.
import '../models/dish.dart';
import '../models/daily_menu.dart';
import '../models/promotion.dart';

class CafeteriaService {
  // Singleton pattern
  static final CafeteriaService _instance = CafeteriaService._internal();
  factory CafeteriaService() => _instance;
  CafeteriaService._internal();

  // Lista de promociones (en producción, esto vendría de una BD)
  final List<Promotion> _promotions = [
    Promotion(
      id: '1',
      title: '2x1 en Cafés',
      description: 'Todos los cafés al 2x1 de 8am a 10am',
      image: 'assets/images/promo_cafe.jpg',
      discountPercentage: 50,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 7)),
    ),
    Promotion(
      id: '2',
      title: 'Combo Estudiantil',
      description: 'Almuerzo + bebida por solo \$3.50',
      image: 'assets/images/promo_combo.jpg',
      discountPercentage: 30,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 14)),
    ),
  ];

  // Menús por día de la semana
  final Map<DayOfWeek, List<Dish>> _weeklyMenu = {
    DayOfWeek.lunes: [
      Dish(
        title: 'Arroz con Pollo',
        description: 'Arroz amarillo con pollo guisado y ensalada',
        image: 'assets/images/arroz_pollo.jpg',
        price: 3.50,
        isMain: true,
      ),
      Dish(
        title: 'Sopa de Verduras',
        description: 'Sopa casera con vegetales frescos',
        image: 'assets/images/sopa.jpg',
        price: 2.00,
        isMain: false,
      ),
    ],
    DayOfWeek.martes: [
      Dish(
        title: 'Lasaña de Carne',
        description: 'Lasaña con carne molida y queso gratinado',
        image: 'assets/images/lasana.jpg',
        price: 4.00,
        isMain: true,
      ),
      Dish(
        title: 'Ensalada César',
        description: 'Lechuga, crutones, parmesano y aderezo césar',
        image: 'assets/images/ensalada.jpg',
        price: 2.50,
        isMain: false,
      ),
    ],
    DayOfWeek.miercoles: [
      Dish(
        title: 'Pollo a la Plancha',
        description: 'Pechuga de pollo con puré de papas',
        image: 'assets/images/pollo.jpg',
        price: 3.75,
        isMain: true,
      ),
      Dish(
        title: 'Jugo Natural',
        description: 'Jugo de frutas de temporada',
        image: 'assets/images/jugo.jpg',
        price: 1.50,
        isMain: false,
      ),
    ],
    DayOfWeek.jueves: [
      Dish(
        title: 'Pasta Carbonara',
        description: 'Pasta cremosa con tocino, huevo y queso parmesano',
        image: 'assets/images/carbonara.jpg',
        price: 4.50,
        isMain: true,
      ),
      Dish(
        title: 'Hamburguesa Especial',
        description: 'Carne de res, queso cheddar, lechuga y salsa especial',
        image: 'assets/images/hamburguesa.jpg',
        price: 5.75,
        isMain: false,
      ),
    ],
    DayOfWeek.viernes: [
      Dish(
        title: 'Pescado Frito',
        description: 'Filete de pescado con arroz y patacones',
        image: 'assets/images/pescado.jpg',
        price: 4.25,
        isMain: true,
      ),
      Dish(
        title: 'Ceviche',
        description: 'Ceviche de camarón fresco',
        image: 'assets/images/ceviche.jpg',
        price: 3.50,
        isMain: false,
      ),
    ],
    DayOfWeek.sabado: [
      Dish(
        title: 'Brunch Especial',
        description: 'Huevos, tocino, pancakes y fruta',
        image: 'assets/images/brunch.jpg',
        price: 5.00,
        isMain: true,
      ),
    ],
    DayOfWeek.domingo: [], // Cerrado los domingos
  };

  // Obtener promociones activas
  List<Promotion> getActivePromotions() {
    return _promotions.where((p) => p.isValid).toList();
  }

  // Obtener todas las promociones
  List<Promotion> getAllPromotions() {
    return List.from(_promotions);
  }

  // Agregar nueva promoción
  void addPromotion(Promotion promotion) {
    _promotions.add(promotion);
  }

  // Eliminar promoción
  void removePromotion(String id) {
    _promotions.removeWhere((p) => p.id == id);
  }

  // Actualizar promoción
  void updatePromotion(Promotion promotion) {
    final index = _promotions.indexWhere((p) => p.id == promotion.id);
    if (index != -1) {
      _promotions[index] = promotion;
    }
  }

  // Obtener menú del día
  DailyMenu getMenuForDay(DayOfWeek day) {
    final dishes = _weeklyMenu[day] ?? [];
    return DailyMenu(
      day: day,
      dishes: dishes,
      date: DateTime.now(),
    );
  }

  // Obtener menú de hoy
  DailyMenu getTodayMenu() {
    final today = DateTime.now().toDayOfWeek();
    return getMenuForDay(today);
  }

  // Obtener menú de la semana
  List<DailyMenu> getWeeklyMenu() {
    return DayOfWeek.values.map((day) => getMenuForDay(day)).toList();
  }
}
