import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_taskhub/dashboard/task_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// A single row representing a task.
/// It features swipe-to-delete, checking/unchecking, and editing.
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggle;
  final Future<void> Function()? onDelete;
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Slidable(
            key: ValueKey(task.id),
            // The left-swipe reveal for the delete action
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.25,
              dismissible: DismissiblePane(onDismissed: () => onDelete?.call()),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    onDelete?.call();
                  },
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
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                ),
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
                  // Title and details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              task.title,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : (isDarkMode
                                          ? Colors.white
                                          : Colors.black87),
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ],
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
                  // The Edit button
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
