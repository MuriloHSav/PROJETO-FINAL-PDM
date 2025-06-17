class Task {
  final String id;
  String title;
  final DateTime date;
  bool isCompleted;
  DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
    this.dueDate,
  });

  // Método copyWith para criar uma nova instância com valores atualizados
  Task copyWith({
    String? id,
    String? title,
    DateTime? date,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}