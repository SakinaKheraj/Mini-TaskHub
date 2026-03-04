import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskTile({
    super.key,
    required this.task,
    this.onToggle,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Slidable(
            key: ValueKey(task.id),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (_) => onDelete?.call(),
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: task.isCompleted
                              ? Colors.purple
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        color: task.isCompleted
                            ? Colors.purple.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: Colors.purple,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: task.isCompleted
                                ? Colors.grey
                                : Colors.black87,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (task.startTime != null && task.endTime != null)
                          Text(
                            '${task.startTime} - ${task.endTime}',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.grey.shade400,
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut);
  }
}
