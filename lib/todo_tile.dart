import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final ValueChanged<bool?>? onChanged;
  final Function(BuildContext)? deleteFunction;

  const TodoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
              borderRadius: BorderRadius.circular(
                // dopasuj do defaultRadius z subThemesData
                12,
              ),
            ),
          ],
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0, // pozwól M3 + FCS kontrolować podniesienie
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => onChanged?.call(!taskCompleted),
            child: Padding(
              // Card dostaje tło z ColorScheme.surface (zblendowane przez FCS),
              // a tekst/ikony z onSurface — kontrast będzie poprawny automatycznie.
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Checkbox(
                    value: taskCompleted,
                    onChanged: onChanged,
                    // Nie ustawiamy ręcznie kolorów — weźmie z motywu (primary/onPrimary itp.)
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      taskName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration:
                            taskCompleted ? TextDecoration.lineThrough : null,
                      ),
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