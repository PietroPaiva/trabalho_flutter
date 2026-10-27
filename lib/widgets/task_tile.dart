import 'package:auroria/models/task.dart';
import 'package:auroria/theme/app_theme.dart';
import 'package:auroria/widgets/fade_slide_in.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final done = task.done;
    return FadeSlideIn(
      duration: const Duration(milliseconds: 350),
      offset: 14,
      child: Dismissible(
        key: ValueKey(task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0x00FF3D6E), Color(0xFFFF3D6E)],
            ),
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: done
                ? AppColors.doneGradient
                : const LinearGradient(
                    colors: [Color(0x26FFFFFF), Color(0x14FFFFFF)],
                  ),
            border: Border.all(
              color: done ? const Color(0x4D2DE2E6) : AppColors.glassBorder,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 6, 10),
                child: Row(
                  children: [
                    _CheckOrb(done: done),
                    const SizedBox(width: 14),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: done ? AppColors.mutedText : Colors.white,
                          decoration: done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: AppColors.cyan,
                          decorationThickness: 2,
                        ),
                        child: Text(task.title),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remover',
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckOrb extends StatelessWidget {
  const _CheckOrb({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: done ? AppColors.coolGradient : AppColors.clearGradient,
        border: Border.all(
          color: done ? Colors.transparent : const Color(0x99FFFFFF),
          width: 2,
        ),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: done ? 1 : 0,
        child: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
      ),
    );
  }
}