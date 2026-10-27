import 'package:auroria/utils/text_utils.dart';

class Task {
  const Task({
    required this.id,
    required this.title,
    this.done = false,
  });

  final String id;
  final String title;
  final bool done;

  Task copyWith({String? title, bool? done}) => Task(
        id: id,
        title: title ?? this.title,
        done: done ?? this.done,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'done': done,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as String,
        title: map['title'] as String,
        done: map['done'] as bool? ?? false,
      );
}

int compareTasks(Task a, Task b) {
  if (a.done != b.done) {
    return a.done ? 1 : -1;
  }
  return removeAccents(a.title).compareTo(removeAccents(b.title));
}