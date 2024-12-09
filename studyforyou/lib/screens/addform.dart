import 'package:flutter/material.dart';
import 'package:studyforyou/models/note_model.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  String _noteName = '';
  DateTime? _dateTimeNote;
  Priority? _priority;
  Type? _type;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dateTimeNote = pickedDate;
      });
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        border: const OutlineInputBorder(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Form",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  maxLength: 20,
                  decoration: _inputDecoration("ชื่อโปรเจค"),
                  validator: (value) =>
                      value?.isEmpty ?? true ? "กรุณาป้อนชื่อโปรเจค" : null,
                  onSaved: (value) => _noteName = value!,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dateTimeNote == null
                            ? "ยังไม่ได้เลือกวันที่"
                            : "ระบุวันที่สิ้นสุด: ${_dateTimeNote!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Priority>(
                  decoration: _inputDecoration("ลำดับความสำคัญ"),
                  value: _priority,
                  items: Priority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority.detail),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _priority = value),
                  validator: (value) =>
                      value == null ? "กรุณาเลือกลำดับความสำคัญ" : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Type>(
                  decoration: _inputDecoration("ประเภทงาน"),
                  value: _type,
                  items: Type.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.detail),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _type = value),
                  validator: (value) =>
                      value == null ? "กรุณาเลือกประเภทงาน" : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (_dateTimeNote == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("กรุณาเลือกวันที่")),
                        );
                        return;
                      }
                      Navigator.pop(
                        context,
                        Note(
                          noteName: _noteName,
                          dateTimeNote: _dateTimeNote!,
                          priority: _priority!,
                          type: _type!,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, 
                    crossAxisAlignment: CrossAxisAlignment
                        .center, 
                    children: [
                      Text(
                        "บันทึก",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
