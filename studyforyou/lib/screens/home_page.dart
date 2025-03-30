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
      barrierDismissible: false, // ✅ ป้องกันกดข้างนอกแล้ว Popup หาย
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20)), // ✅ ทำให้ Popup มีมุมโค้ง
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit_note,
                    size: 60, color: Colors.blueAccent), // ✅ ไอคอนด้านบน
                const SizedBox(height: 10),
                const Text(
                  "เพิ่มบันทึกใหม่",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: "กรอกข้อความที่ต้องการบันทึก",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text("ยกเลิก"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        saveNote();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text("บันทึก"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)
        ],
      ),
      child: notedata.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(notedata[dataindex].noteName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                Text(
                    "สิ้นสุดวันที่: ${notedata[dataindex].dateTimeNote.toLocal().toString().split(' ')[0]}",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
                Text("ประเภท: ${notedata[dataindex].type.detail}",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            )
          : const Text("No notes available",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study For You",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
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
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, spreadRadius: 2)
              ],
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
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)
              ],
            ),
            child: Wrap(
              spacing: 20,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final newNote = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddForm()));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LibraryPage()));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReadingTimerPage()));
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
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: showPopupToSaveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // เปลี่ยนเป็นสีขาว
                    foregroundColor: Colors.blueAccent, // เปลี่ยนสีข้อความ
                    elevation: 5, // เพิ่มเงา
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // ทำให้ขอบโค้งมน
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add,
                          color: Colors.blueAccent), // ไอคอนเพิ่มบันทึก
                      SizedBox(width: 10),
                      Text(
                        "เพิ่มบันทึก",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: savedNotes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white, // เปลี่ยนเป็นสีขาว
                          borderRadius:
                              BorderRadius.circular(15), // ทำให้โค้งมน
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.note,
                                color: Colors.blueAccent, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    savedNotes[index].split("\n")[0],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    savedNotes[index].split("\n")[1],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  savedNotes.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
