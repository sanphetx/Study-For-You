import 'package:flutter/material.dart';
import 'package:studyforyou/models/note_model.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    
    notedata.sort((a, b) => a.dateTimeNote.compareTo(b.dateTimeNote));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Library",
        style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notedata.length,
              itemBuilder: (context, index) {
                final note = notedata[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: note.priority.color.withOpacity(0.2),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: note.priority.color,
                      child: Text(
                        note.priority.detail[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      note.noteName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "วันที่สิ้นสุด: ${note.dateTimeNote.toLocal().toString().split(' ')[0]}\n"
                      "ความสำคัญ: ${note.priority.detail}\n"
                      "ประเภท: ${note.type.detail}", 
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("ยืนยันการลบ"),
                            content: Text("คุณต้องการลบงาน \"${note.noteName}\" หรือไม่?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("ยกเลิก"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    notedata.removeAt(index); 
                                  });
                                  Navigator.pop(context); 
                                },
                                child: const Text("ลบ", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
