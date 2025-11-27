import 'package:flutter/material.dart';
import '../../../models/daily_menu.dart';
import '../../../config/app_theme.dart';

class DaySelector extends StatelessWidget {
  final DayOfWeek selectedDay;
  final Function(DayOfWeek) onDaySelected;

  const DaySelector({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = DayOfWeek.values.where((d) => d != DayOfWeek.domingo).toList();
    final today = DateTime.now().toDayOfWeek();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isSelected = day == selectedDay;
        final isToday = day == today;

        return GestureDetector(
          onTap: () => onDaySelected(day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : isToday
                        ? AppTheme.accentColor
                        : Colors.grey.withOpacity(0.3),
                width: isToday && !isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _getDayAbbreviation(day),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                if (isToday)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.white : AppTheme.accentColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getDayAbbreviation(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.lunes:
        return 'Lun';
      case DayOfWeek.martes:
        return 'Mar';
      case DayOfWeek.miercoles:
        return 'Mié';
      case DayOfWeek.jueves:
        return 'Jue';
      case DayOfWeek.viernes:
        return 'Vie';
      case DayOfWeek.sabado:
        return 'Sáb';
      case DayOfWeek.domingo:
        return 'Dom';
    }
  }
}
