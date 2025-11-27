// Modelo para el menú diario
import 'dish.dart';

enum DayOfWeek {
  lunes,
  martes,
  miercoles,
  jueves,
  viernes,
  sabado,
  domingo,
}

class DailyMenu {
  final DayOfWeek day;
  final List<Dish> dishes;
  final DateTime date;

  DailyMenu({
    required this.day,
    required this.dishes,
    required this.date,
  });

  // Obtener solo platos principales
  List<Dish> get mainDishes => dishes.where((d) => d.isMain).toList();

  // Obtener platos secundarios
  List<Dish> get sideDishes => dishes.where((d) => !d.isMain).toList();

  // Nombre del día en español
  String get dayName {
    switch (day) {
      case DayOfWeek.lunes:
        return 'Lunes';
      case DayOfWeek.martes:
        return 'Martes';
      case DayOfWeek.miercoles:
        return 'Miércoles';
      case DayOfWeek.jueves:
        return 'Jueves';
      case DayOfWeek.viernes:
        return 'Viernes';
      case DayOfWeek.sabado:
        return 'Sábado';
      case DayOfWeek.domingo:
        return 'Domingo';
    }
  }
}

// Extensión para obtener el DayOfWeek desde DateTime
extension DateTimeDayOfWeek on DateTime {
  DayOfWeek toDayOfWeek() {
    switch (weekday) {
      case 1:
        return DayOfWeek.lunes;
      case 2:
        return DayOfWeek.martes;
      case 3:
        return DayOfWeek.miercoles;
      case 4:
        return DayOfWeek.jueves;
      case 5:
        return DayOfWeek.viernes;
      case 6:
        return DayOfWeek.sabado;
      case 7:
        return DayOfWeek.domingo;
      default:
        return DayOfWeek.lunes;
    }
  }
}
