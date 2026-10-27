import 'package:auroria/screens/tasks_screen.dart';
import 'package:auroria/services/auth_service.dart';
import 'package:auroria/services/task_service.dart';
import 'package:auroria/theme/app_theme.dart';
import 'package:auroria/utils/text_utils.dart';
import 'package:auroria/widgets/aurora_calendar.dart';
import 'package:auroria/widgets/fade_slide_in.dart';
import 'package:auroria/widgets/glass_card.dart';
import 'package:auroria/widgets/gradient_background.dart';
import 'package:auroria/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  void _openTasks() {
    final day = _selectedDay;
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            TasksScreen(day: day),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  String _summary(int pending, int done) {
    if (pending + done == 0) return 'Nenhuma tarefa neste dia';
    final p = pending == 1 ? 'pendente' : 'pendentes';
    final d = done == 1 ? 'concluída' : 'concluídas';
    return '$pending $p · $done $d';
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskService>();
    final user = context.watch<AuthService>().current;
    final dayTasks = tasks.tasksOf(_selectedDay);
    final done = dayTasks.where((task) => task.done).length;
    final pending = dayTasks.length - done;
    final firstName = (user?.name ?? '').trim().split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: FadeSlideIn(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, $firstName!',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'Escolha um dia para planejar',
                              style: TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glass,
                        ),
                        child: IconButton(
                          tooltip: 'Sair',
                          onPressed: () => context.read<AuthService>().logout(),
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GlassCard(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                    child: AuroraCalendar(
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay,
                      eventLoader: tasks.tasksOf,
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                        });
                      },
                      onPageChanged: (focused) => _focusedDay = focused,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.coolGradient,
                              ),
                              child: const Icon(
                                Icons.event_available_rounded,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatLongDate(_selectedDay),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _summary(pending, done),
                                    style: const TextStyle(
                                      color: AppColors.mutedText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            label: 'Ver tarefas do dia',
                            icon: Icons.arrow_forward_rounded,
                            onPressed: _openTasks,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}