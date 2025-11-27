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
    Promotion(
      id: '3',
      title: 'DESAYUNO EJECUTIVO',
      description: 'Café + sándwich + jugo natural',
      image: 'assets/images/promo_desayuno.jpg',
      discountPercentage: 35,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 3)),
    ),
    Promotion(
      id: '4',
      title: 'CAFÉ AMERICANO XL',
      description: '400ml + galleta gratis',
      image: 'assets/images/promo_cafe_grande.jpg',
      discountPercentage: 40,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 4)),
    ),
    Promotion(
      id: '5',
      title: 'JUGOS 2x1',
      description: 'Cualquier combinación de jugos',
      image: 'assets/images/promo_jugos.jpg',
      discountPercentage: 50,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Promotion(
      id: '6',
      title: 'POSTRE DEL DÍA',
      description: 'Cheesecake o brownie + café',
      image: 'assets/images/promo_postre.jpg',
      discountPercentage: 35,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Promotion(
      id: '7',
      title: 'BURGER + PAPAS',
      description: 'Doble carne + cheddar + papas',
      image: 'assets/images/promo_burger.jpg',
      discountPercentage: 25,
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 4)),
    ),
    Promotion(
      id: '8',
      title: 'HAPPY HOUR',
      description: '2x1 en todos los cafés después de 3pm',
      image: 'assets/images/promo_happy_hour.jpg',
      discountPercentage: 50,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
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
      Dish(
        title: 'Jugo de Naranja',
        description: 'Jugo natural recién exprimido',
        image: 'assets/images/jugo_naranja.jpg',
        price: 1.20,
        isMain: false,
      ),
      Dish(
        title: 'Café Americano',
        description: 'Café de la casa recién molido',
        image: 'assets/images/cafe_americano.jpg',
        price: 1.00,
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
      Dish(
        title: 'Sopa de Lentejas',
        description: 'Sopa nutritiva con lentejas y chorizo',
        image: 'assets/images/sopa_lentejas.jpg',
        price: 2.20,
        isMain: false,
      ),
      Dish(
        title: 'Agua de Hierbaluisa',
        description: 'Agua aromática refrescante',
        image: 'assets/images/agua_hierbaluisa.jpg',
        price: 1.00,
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
      Dish(
        title: 'Ensalada Mixta',
        description: 'Tomate, cebolla, pepino y zanahoria',
        image: 'assets/images/ensalada_mixta.jpg',
        price: 1.80,
        isMain: false,
      ),
      Dish(
        title: 'Té de Manzanilla',
        description: 'Té relajante natural',
        image: 'assets/images/te_manzanilla.jpg',
        price: 1.00,
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
      Dish(
        title: 'Papas Fritas',
        description: 'Papas crujientes con sal',
        image: 'assets/images/papas_fritas.jpg',
        price: 1.50,
        isMain: false,
      ),
      Dish(
        title: 'Gaseosa',
        description: 'Coca Cola o Sprite helada',
        image: 'assets/images/gaseosa.jpg',
        price: 1.20,
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
      Dish(
        title: 'Arroz con Menestra',
        description: 'Arroz con lentejas y carne',
        image: 'assets/images/arroz_menestra.jpg',
        price: 3.80,
        isMain: false,
      ),
      Dish(
        title: 'Limonada',
        description: 'Limonada casera refrescante',
        image: 'assets/images/limonada.jpg',
        price: 1.20,
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
      Dish(
        title: 'Sándwich de Jamón y Queso',
        description: 'Sándwich caliente con jamón y queso derretido',
        image: 'assets/images/sandwich_jamon.jpg',
        price: 2.50,
        isMain: false,
      ),
      Dish(
        title: 'Yogurt con Granola',
        description: 'Yogurt natural con granola y frutas',
        image: 'assets/images/yogurt_granola.jpg',
        price: 2.00,
        isMain: false,
      ),
      Dish(
        title: 'Jugo de Piña',
        description: 'Jugo de piña colada natural',
        image: 'assets/images/jugo_pina.jpg',
        price: 1.50,
        isMain: false,
      ),
    ],
    DayOfWeek.domingo: [
      Dish(
        title: 'Fritada Especial',
        description: 'Fritada de chancho con mote y sarza',
        image: 'assets/images/fritada.jpg',
        price: 5.50,
        isMain: true,
      ),
      Dish(
        title: 'Humita',
        description: 'Humita fresca envuelta en hoja de maíz',
        image: 'assets/images/humita.jpg',
        price: 2.50,
        isMain: false,
      ),
      Dish(
        title: 'Locro de Papa',
        description: 'Locro ecuatoriano con queso y aguacate',
        image: 'assets/images/locro_papa.jpg',
        price: 3.00,
        isMain: false,
      ),
      Dish(
        title: 'Morocho',
        description: 'Bebida tradicional de maíz',
        image: 'assets/images/morocho.jpg',
        price: 1.20,
        isMain: false,
      ),
    ],
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

// ddaa