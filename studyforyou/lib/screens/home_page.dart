import 'dart:async';
import 'package:flutter/material.dart';
import 'package:studyforyou/models/note_model.dart';
import 'package:studyforyou/screens/addform.dart';
import 'package:studyforyou/screens/library_page.dart';
import 'package:studyforyou/screens/readingTimer_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int dataindex = 0;
  late Timer _timer;
  final TextEditingController _controller = TextEditingController();
  List<String> savedNotes = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (notedata.isNotEmpty) {
        setState(() {
          dataindex = (dataindex + 1) % notedata.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); 
    _controller.dispose(); 
    super.dispose();
  }

  void saveNote() {
    if (_controller.text.isNotEmpty) {
      String timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      setState(() {
        savedNotes.add("${_controller.text} \n(บันทึกเมื่อ: $timestamp)");
        _controller.clear();
      });
    }
  }

  void showPopupToSaveNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("เพิ่มบันทึก"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "กรอกข้อความที่ต้องการบันทึก"),
            keyboardType: TextInputType.multiline,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("ยกเลิก")),
            TextButton(onPressed: () { saveNote(); Navigator.pop(context); }, child: const Text("บันทึก")),
          ],
        );
      },
    );
  }

  

  Widget buildNoteSection() {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
      ),
      child: notedata.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(notedata[dataindex].noteName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                Text("สิ้นสุดวันที่: ${notedata[dataindex].dateTimeNote.toLocal().toString().split(' ')[0]}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
                Text("ประเภท: ${notedata[dataindex].type.detail}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            )
          : const Text("No notes available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study For You",style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.book, size: 30, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 20),
                buildNoteSection(),
              ],
            ),
          ),
          const SizedBox(height: 20),
         
Container(
  padding: const EdgeInsets.all(20),
  margin: const EdgeInsets.all(10),
  alignment: Alignment.center,
  decoration: const BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)],
  ),
  child: Wrap(
    spacing: 20,
    children: [
      ElevatedButton(
        onPressed: () async {
          final newNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddForm()));
          if (newNote != null && newNote is Note) {
            setState(() {
              notedata.add(newNote);
            });
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,  
          backgroundColor: Colors.white,  
          padding: const EdgeInsets.all(12),  
          shape: const CircleBorder(),  
        ),
        child: const Icon(Icons.add_box_rounded, size: 30),  
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LibraryPage()));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          shape: const CircleBorder(),
        ),
        child: const Icon(Icons.library_books, size: 30),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReadingTimerPage()));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          shape: const CircleBorder(),
        ),
        child: const Icon(Icons.timer, size: 30),
      ),
    ],
  ),
),

          
          Container(
            width: double.infinity,
            height: 500,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: showPopupToSaveNote,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("เพิ่มบันทึก", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: savedNotes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 1)],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          title: Text(savedNotes[index], style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
