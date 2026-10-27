import 'package:auroria/models/task.dart';
import 'package:auroria/theme/app_theme.dart';
import 'package:auroria/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AuroraCalendar extends StatelessWidget {
  const AuroraCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.eventLoader,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final void Function(DateTime selected, DateTime focused) onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final List<Task> Function(DateTime day) eventLoader;

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Task>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: focusedDay,
      locale: 'pt_BR',
      rowHeight: 48,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableCalendarFormats: const {CalendarFormat.month: 'Mês'},
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,
      eventLoader: eventLoader,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) =>
            capitalize(DateFormat.yMMMM(locale).format(date)),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leftChevronIcon: const Icon(
          Icons.chevron_left_rounded,
          color: AppColors.cyan,
          size: 28,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.cyan,
          size: 28,
        ),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: AppColors.mutedText),
        weekendStyle: TextStyle(color: AppColors.orange),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: const TextStyle(color: Colors.white),
        weekendTextStyle: const TextStyle(color: Colors.white),
        todayTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.cyan, width: 2),
        ),
        selectedDecoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: Color(0x66FF3D9A),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
      calendarBuilders: CalendarBuilders<Task>(
        markerBuilder: (context, day, events) {
          if (events.isEmpty) return null;
          final allDone = events.every((task) => task.done);
          final isSelected = isSameDay(selectedDay, day);
          final color = isSelected
              ? Colors.white
              : (allDone ? AppColors.cyan : AppColors.yellow);
          return Positioned(
            bottom: 5,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(color: color, blurRadius: 6),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}