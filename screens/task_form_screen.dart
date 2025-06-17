import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart'; // Importar o modelo Task

class TaskFormScreen extends StatefulWidget {
  final Function(String, DateTime?) onSaveTask;
  final Task? taskToEdit; // NOVO: Tarefa opcional para edição

  const TaskFormScreen({
    super.key,
    required this.onSaveTask,
    this.taskToEdit, // NOVO: Parâmetro opcional
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _taskController = TextEditingController();
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _taskController.text = widget.taskToEdit!.title;
      _selectedDueDate = widget.taskToEdit!.dueDate;
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(), // Usa data existente se houver
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)), // Permite selecionar datas passadas para edição
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_taskController.text.isEmpty) return;
    widget.onSaveTask(_taskController.text, _selectedDueDate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskToEdit == null ? 'Nova Tarefa' : 'Editar Tarefa'), // Título dinâmico
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Descrição da tarefa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text(
                    _selectedDueDate == null
                        ? 'Adicionar prazo'
                        : 'Prazo: ${DateFormat('dd/MM/yyyy').format(_selectedDueDate!)}',
                  ),
                ),
                if (_selectedDueDate != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _selectedDueDate = null),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.taskToEdit == null ? 'Salvar Tarefa' : 'Atualizar Tarefa'), // Texto do botão dinâmico
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}