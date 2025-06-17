import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'task_form_screen.dart';
import 'stats_screen.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../utils/app_enums.dart'; // Importar os enums

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [
    Task(id: '1', title: 'Comprar leite', date: DateTime.now()),
    Task(id: '2', title: 'Estudar Flutter', date: DateTime.now()),
    Task(id: '3', title: 'Pagar contas', date: DateTime.now(), dueDate: DateTime.now().add(const Duration(days: 2))),
    Task(id: '4', title: 'Agendar médico', date: DateTime.now(), dueDate: DateTime.now().subtract(const Duration(days: 1)), isCompleted: false),
    Task(id: '5', title: 'Fazer exercícios', date: DateTime.now()),
    Task(id: '6', title: 'Ler livro', date: DateTime.now(), dueDate: DateTime.now().add(const Duration(days: 5))),
    Task(id: '7', title: 'Reunião de equipe', date: DateTime.now().subtract(const Duration(days: 3)), dueDate: DateTime.now().add(const Duration(hours: 2)), isCompleted: false),
    Task(id: '8', title: 'Enviar relatório', date: DateTime.now().subtract(const Duration(days: 10)), dueDate: DateTime.now().subtract(const Duration(days: 5)), isCompleted: true),
    Task(id: '9', title: 'Planejar viagem', date: DateTime.now().subtract(const Duration(days: 1)), dueDate: DateTime.now().add(const Duration(days: 15)), isCompleted: false),
  ];

  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.creationDateDesc;

  List<Task> get _filteredAndSortedTasks {
    List<Task> filteredTasks = List.from(_tasks); // Cópia para não modificar a original

    // Filtragem
    if (_currentFilter == TaskFilter.completed) {
      filteredTasks = filteredTasks.where((task) => task.isCompleted).toList();
    } else if (_currentFilter == TaskFilter.pending) {
      filteredTasks = filteredTasks.where((task) => !task.isCompleted).toList();
    } else if (_currentFilter == TaskFilter.overdue) {
      filteredTasks = filteredTasks
          .where((task) => !task.isCompleted && task.dueDate != null && task.dueDate!.isBefore(DateTime.now()))
          .toList();
    } else if (_currentFilter == TaskFilter.today) {
      final today = DateTime.now();
      filteredTasks = filteredTasks
          .where((task) =>
              !task.isCompleted &&
              task.dueDate != null &&
              task.dueDate!.year == today.year &&
              task.dueDate!.month == today.month &&
              task.dueDate!.day == today.day)
          .toList();
    } else if (_currentFilter == TaskFilter.thisWeek) {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Segunda-feira
      final endOfWeek = startOfWeek.add(const Duration(days: 6)); // Domingo

      filteredTasks = filteredTasks
          .where((task) =>
              !task.isCompleted &&
              task.dueDate != null &&
              task.dueDate!.isAfter(startOfWeek.subtract(const Duration(days: 1))) && // Ajuste para incluir o dia de início
              task.dueDate!.isBefore(endOfWeek.add(const Duration(days: 1)))) // Ajuste para incluir o dia de fim
          .toList();
    }

    // Ordenação
    filteredTasks.sort((a, b) {
      switch (_currentSort) {
        case TaskSort.creationDateAsc:
          return a.date.compareTo(b.date);
        case TaskSort.creationDateDesc:
          return b.date.compareTo(a.date);
        case TaskSort.dueDateAsc:
          // Tarefas sem prazo vão para o final
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        case TaskSort.dueDateDesc:
          // Tarefas sem prazo vão para o início (ou para o final dependendo da lógica desejada)
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return -1; // Coloca nulls antes em ordem decrescente
          if (b.dueDate == null) return 1;
          return b.dueDate!.compareTo(a.dueDate!);
        case TaskSort.titleAsc:
          return a.title.compareTo(b.title);
        case TaskSort.titleDesc:
          return b.title.compareTo(a.title);
        }
    });

    return filteredTasks;
  }

  void _addTask(String taskTitle, DateTime? dueDate) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: taskTitle,
      date: DateTime.now(),
      dueDate: dueDate,
    );
    setState(() {
      _tasks.add(newTask);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa "${newTask.title}" adicionada!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteTask(String id) {
    // A variável taskToDelete é usada para o SnackBar no Dismissible do TaskItem.
    // Se o SnackBar fosse aqui, precisaria dela. Como está no TaskItem, podemos remover.
    // final taskToDelete = _tasks.firstWhere((task) => task.id == id); // Removida por aviso de não uso
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
    // Feedback visual para exclusão é tratado no Dismissible do TaskItem
  }

  void _toggleTaskStatus(String id) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _tasks[taskIndex].isCompleted
                  ? 'Tarefa "${_tasks[taskIndex].title}" concluída!'
                  : 'Tarefa "${_tasks[taskIndex].title}" reaberta!',
            ),
            backgroundColor: _tasks[taskIndex].isCompleted ? Colors.orange : Theme.of(context).colorScheme.primary,
          ),
        );
      }
    });
  }

  void _editTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(
          taskToEdit: task,
          onSaveTask: (newTitle, newDueDate) {
            setState(() {
              final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
              if (taskIndex != -1) {
                _tasks[taskIndex].title = newTitle;
                _tasks[taskIndex].dueDate = newDueDate;
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tarefa "${newTitle}" atualizada!'),
                backgroundColor: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper para obter o texto do filtro selecionado
  String _getFilterText(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'Todas';
      case TaskFilter.completed:
        return 'Concluídas';
      case TaskFilter.pending:
        return 'Pendentes';
      case TaskFilter.overdue:
        return 'Vencidas';
      case TaskFilter.today:
        return 'Hoje';
      case TaskFilter.thisWeek:
        return 'Esta Semana';
      }
  }

  // Helper para obter o texto da ordenação selecionada
  String _getSortText(TaskSort sort) {
    switch (sort) {
      case TaskSort.creationDateAsc:
        return 'Criação (Antigas)';
      case TaskSort.creationDateDesc:
        return 'Criação (Recentes)';
      case TaskSort.dueDateAsc:
        return 'Prazo (Mais Cedo)';
      case TaskSort.dueDateDesc:
        return 'Prazo (Mais Tarde)';
      case TaskSort.titleAsc:
        return 'Título (A-Z)';
      case TaskSort.titleDesc:
        return 'Título (Z-A)';
      }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final displayedTasks = _filteredAndSortedTasks; // Usa a lista processada

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Tarefas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatsScreen(
                    totalTasks: _tasks.length,
                    completedTasks: _tasks.where((task) => task.isCompleted).length,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Olá! Você tem ${_tasks.length} tarefa(s).',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Chip(
                  label: Text(
                    _tasks.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
              ],
            ),
          ),
          // Seção de Filtros (Chips)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8.0, // Espaçamento entre os chips
                children: TaskFilter.values.map((filter) {
                  return ChoiceChip(
                    label: Text(_getFilterText(filter)),
                    selected: _currentFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _currentFilter = selected ? filter : TaskFilter.all; // Se deselecionar, volta para "Todas"
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.secondary, // Cor de destaque quando selecionado
                    labelStyle: TextStyle(
                      color: _currentFilter == filter
                          ? Theme.of(context).colorScheme.onSecondary // Cor do texto quando selecionado
                          : Theme.of(context).textTheme.bodyMedium?.color, // Cor do texto normal
                    ),
                    side: BorderSide(
                      color: _currentFilter == filter
                          ? Theme.of(context).colorScheme.secondary // Borda colorida quando selecionado
                          : Theme.of(context).colorScheme.outline, // Borda padrão
                    ),
                    showCheckmark: false, // Opcional: remover o ícone de checkmark
                  );
                }).toList(),
              ),
            ),
          ),
          // Seção de Ordenação (PopupMenuButton)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordenado por: ${_getSortText(_currentSort)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                PopupMenuButton<TaskSort>(
                  icon: const Icon(Icons.sort, color: Colors.grey),
                  onSelected: (TaskSort selectedSort) {
                    setState(() {
                      _currentSort = selectedSort;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return TaskSort.values.map((sort) {
                      return PopupMenuItem<TaskSort>(
                        value: sort,
                        child: Row(
                          children: [
                            Icon(
                              _currentSort == sort ? Icons.check : null,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(_getSortText(sort)),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.assignment_turned_in_outlined,
                            size: 80,
                            color: Colors.grey[400]),
                        const SizedBox(height: 20),
                        Text(
                          _currentFilter == TaskFilter.all
                              ? 'Que tal adicionar sua primeira tarefa?'
                              : 'Nenhuma tarefa encontrada com este filtro.',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_currentFilter == TaskFilter.all) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Clique no "+" abaixo para começar!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayedTasks.length,
                    itemBuilder: (ctx, index) {
                      return TaskItem(
                        task: displayedTasks[index],
                        onDelete: _deleteTask,
                        onToggleStatus: _toggleTaskStatus,
                        onEdit: _editTask,
                      ).animate().fadeIn(duration: 400.ms, delay: (index * 50).ms).slideY(begin: 0.2, end: 0);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFormScreen(
                onSaveTask: _addTask,
              ),
            ),
          );
        },
        label: const Text(
          'Nova Tarefa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}