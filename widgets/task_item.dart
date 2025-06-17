// lib/widgets/task_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de datas

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String) onDelete;
  final Function(String) onToggleStatus;
  final Function(Task) onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleStatus,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Determine a cor de destaque com base no status da tarefa e prazo
    Color statusColor = Colors.grey; // Default
    if (task.isCompleted) {
      statusColor = Colors.green;
    } else if (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())) {
      statusColor = Colors.red; // Tarefa atrasada
    } else {
      statusColor = Theme.of(context).colorScheme.secondary; // Tarefa pendente e no prazo
    }

    return Dismissible( // Permite deslizar para ações
      key: ValueKey(task.id),
      direction: DismissDirection.horizontal, // Permite deslizar para ambos os lados
      background: Container(
        color: Colors.redAccent, // Fundo vermelho para exclusão
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      secondaryBackground: Container(
        color: Colors.blueAccent, // Fundo azul para edição
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: const Icon(Icons.edit, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Deslize da esquerda para a direita (excluir)
          final bool confirm = await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: Text('Tem certeza de que deseja excluir "${task.title}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Excluir', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
          return confirm;
        } else if (direction == DismissDirection.endToStart) {
          // Deslize da direita para a esquerda (editar)
          onEdit(task);
          return false; // Não remove o item da lista ao editar
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onDelete(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tarefa "${task.title}" excluída!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2), // Margem menor para alinhar
        elevation: 4, // Sombra suave
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Bordas arredondadas
        child: InkWell( // Torna o card clicável
          onTap: () => onToggleStatus(task.id), // Altera status ao clicar no card
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícone de status (checkbox ou ícone de atraso/concluído)
                GestureDetector( // Permite tocar apenas no ícone para alternar status
                  onTap: () => onToggleStatus(task.id),
                  child: CircleAvatar(
                    backgroundColor: statusColor,
                    radius: 18,
                    child: Icon(
                      task.isCompleted
                          ? Icons.check_rounded
                          : (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())
                              ? Icons.error_outline // Atrasado
                              : Icons.circle_outlined), // Pendente
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Título e Data
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                          color: task.isCompleted ? Colors.grey : (Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Criado em: ${DateFormat('dd/MM/yyyy').format(task.date)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (task.dueDate != null)
                        Text(
                          'Prazo: ${DateFormat('dd/MM/yyyy').format(task.dueDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted
                                ? Colors.red[700] // Prazo vencido
                                : Colors.grey[600],
                            fontWeight: task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Botão de editar (redundante com Dismissible, mas pode ser útil como fallback)
                // IconButton(
                //   icon: Icon(Icons.edit, color: Colors.blueGrey),
                //   onPressed: () => onEdit(task),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}