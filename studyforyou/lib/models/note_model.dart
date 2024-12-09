import 'package:flutter/material.dart';

enum Priority {
  important(detail: "สำคัญและเร่งด่วน", color: Colors.red),
  decide(detail: "สำคัญแต่ไม่เร่งด่วน", color: Colors.orange),
  delegate(detail: "ไม่สำคัญแต่เร่งด่วน", color: Colors.yellow),
  dump(detail: "ไม่สำคัญและไม่เร่งด่วน", color: Colors.green);

  const Priority({required this.detail, required this.color});
  final String detail;
  final Color color;
}

enum Type {
  task(detail: "งาน/โปรเจค"),
  appointment(detail: "นัดหมาย"),
  note(detail: "โน๊ต"),
  others(detail: "อื่นๆ");

  const Type({required this.detail});
  final String detail;
}

class Note {
  Note({
    required this.noteName,
    required this.dateTimeNote,
    required this.priority,
    required this.type,  
  });

  String noteName;
  DateTime dateTimeNote;
  Priority priority;
  Type type; 
}

List<Note> notedata = [
  Note(
    noteName: 'โปรเจคร้านอาหาร',
    priority: Priority.important,
    dateTimeNote: DateTime(2025, 2, 4),
    type: Type.task, 
  ),
  Note(
    noteName: 'นัดหมายกับลูกค้า',
    priority: Priority.decide,
    dateTimeNote: DateTime(2025, 1, 2),
    type: Type.appointment, 
  ),
  Note(
    noteName: 'โน๊ตสำหรับการประชุม',
    priority: Priority.delegate,
    dateTimeNote: DateTime(2024, 12, 25),
    type: Type.note,  
  ),
];
