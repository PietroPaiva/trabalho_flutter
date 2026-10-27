import 'package:auroria/services/task_service.dart';
import 'package:auroria/theme/app_theme.dart';
import 'package:auroria/utils/text_utils.dart';
import 'package:auroria/widgets/add_task_dialog.dart';
import 'package:auroria/widgets/glass_card.dart';
import 'package:auroria/widgets/gradient_background.dart';
import 'package:auroria/widgets/gradient_button.dart';
import 'package:auroria/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, required this.day});

  final DateTime day;

  Future<void> _addTask(BuildContext context) async {
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          AddTaskDialog(dateLabel: formatLongDate(day)),
    );
    if (title == null || !context.mounted) return;
    context.read<TaskService>().add(day, title);
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<TaskService>();
    final tasks = service.tasksOf(day);
    final doneCount = tasks.where((task) => task.done).length;
    final progress = tasks.isEmpty ? 0.0 : doneCount / tasks.length;

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      floatingActionButton: GradientButton(
        label: 'Nova tarefa',
        icon: Icons.add_rounded,
        onPressed: () => _addTask(context),
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 20, 0),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.glass,
                      ),
                      child: IconButton(
                        tooltip: 'Voltar',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tarefas do dia',
                            style: TextStyle(
                              color: AppColors.mutedText,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            formatLongDate(day),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$doneCount de ${tasks.length} concluídas',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(end: progress),
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Stack(
                              children: [
                                Container(
                                  height: 10,
                                  color: const Color(0x22FFFFFF),
                                ),
                                FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: value,
                                  child: Container(
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      gradient: AppColors.coolGradient,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: tasks.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Padding(
                            key: ValueKey(task.id),
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TaskTile(
                              task: task,
                              onToggle: () => service.toggle(day, task.id),
                              onDelete: () => service.remove(day, task.id),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.doneGradient,
              ),
              child: const Icon(
                Icons.nightlight_round,
                size: 46,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Céu limpo por aqui',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Toque em "Nova tarefa" para começar o dia.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedText),
            ),
          ],
        ),
      ),
    );
  }
}