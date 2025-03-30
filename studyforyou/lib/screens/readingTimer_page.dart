import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studyforyou/models/readingHistory.dart';

class ReadingTimerPage extends StatefulWidget {
  const ReadingTimerPage({super.key});

  @override
  _ReadingTimerPageState createState() => _ReadingTimerPageState();
}

class _ReadingTimerPageState extends State<ReadingTimerPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  bool _isRunning = false;
  int _totalReadingTimeInSeconds = 0;
  final TextEditingController _bookController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  List<String> selectedBooks = []; // ✅ รายการหนังสือที่ถูกเลือกให้แสดง

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (_isRunning) {
      setState(() {
        _totalReadingTimeInSeconds = _stopwatch.elapsed.inSeconds;
      });
    }
  }

  void _startStopwatch() {
    if (_bookController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("กรุณากรอกชื่อหนังสือก่อนเริ่มจับเวลา"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isRunning = true;
      _stopwatch.start();
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
    });
    _stopwatch.stop();
    _showSaveDialog();
  }

  void _addToHistory() {
    final page = int.tryParse(_pageController.text);
    if (page == null || page <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณากรอกหน้าที่อ่านจบให้ถูกต้อง')));
      return;
    }
    final duration = _stopwatch.elapsed;
    final formattedTime =
        "${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

    setState(() {
      readingHistoryData.insert(
          0,
          ReadingHistory(
            book: _bookController.text,
            page: page,
            time: formattedTime,
            dateRead: DateTime.now(), // ✅ แก้ไขให้กำหนดค่าเป็นวันปัจจุบัน
          ));
      _bookController.clear();
      _pageController.clear();
    });

    _stopwatch.reset();
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("บันทึกหน้าหนังสือ"),
          content: TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'หน้าที่อ่านจบ'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () {
                _addToHistory();
                Navigator.of(context).pop();
              },
              child: const Text("บันทึก"),
            ),
          ],
        );
      },
    );
  }

  void _toggleBookSelection(String bookName) {
    setState(() {
      if (selectedBooks.contains(bookName)) {
        selectedBooks.remove(bookName);
      } else {
        selectedBooks.add(bookName);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _totalReadingTimeInSeconds ~/ 3600;
    final minutes = (_totalReadingTimeInSeconds % 3600) ~/ 60;
    final seconds = _totalReadingTimeInSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reading Time",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimerDisplay(hours, minutes, seconds),
                  const SizedBox(height: 30),
                  _buildBookInputField(),
                  const SizedBox(height: 10),
                  _buildControlButtons(),
                  const SizedBox(height: 30),
                  const Text("📌 เลือกหนังสือที่ต้องการแสดง:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildBookFilterChips(), // ✅ เพิ่มฟิลเตอร์ที่เป็น Chip
                  const SizedBox(height: 20),
                  _buildReadingHistory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookFilterChips() {
    Set<String> uniqueBooks =
        readingHistoryData.map((history) => history.book).toSet();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: uniqueBooks.map((bookName) {
        bool isSelected = selectedBooks.contains(bookName);

        return FilterChip(
          label: Text(bookName),
          selected: isSelected,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          selectedColor: Colors.blueAccent,
          checkmarkColor: Colors.white,
          backgroundColor: Colors.grey[200],
          onSelected: (bool value) {
            setState(() {
              if (value) {
                selectedBooks.add(bookName);
              } else {
                selectedBooks.remove(bookName);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTimerDisplay(int hours, int minutes, int seconds) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2)
        ],
      ),
      child: Center(
        child: Text(
          "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
          style: const TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBookInputField() {
    return TextField(
      controller: _bookController,
      decoration: InputDecoration(
        labelText: 'ชื่อหนังสือ',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: !_isRunning ? _startStopwatch : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            child: const Text("เริ่มจับเวลา",
                style: TextStyle(color: Colors.white))),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: _isRunning ? _stopStopwatch : null,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
          child:
              const Text("หยุดจับเวลา", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildBookSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: readingHistoryData.map((history) {
        return CheckboxListTile(
          title: Text(history.book),
          value: selectedBooks.contains(history.book),
          onChanged: (bool? value) {
            _toggleBookSelection(history.book);
          },
        );
      }).toList(),
    );
  }
void _continueReading(ReadingHistory history) {
  setState(() {
    _bookController.text = history.book;
    _pageController.text = history.page.toString();
    _totalReadingTimeInSeconds = 0;
    _stopwatch.reset();
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("📖 ดึงข้อมูล '${history.book}' กลับมาอ่านต่อ"),
      backgroundColor: Colors.blueAccent,
    ),
  );
}

 Widget _buildReadingHistory() {
  List<ReadingHistory> filteredHistory = readingHistoryData
      .where((history) => selectedBooks.isEmpty || selectedBooks.contains(history.book))
      .toList();

  return Container(
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.blueAccent, width: 2),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          spreadRadius: 2,
          offset: Offset(2, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("📖 ประวัติการอ่าน:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        const SizedBox(height: 10),
        filteredHistory.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("ไม่มีรายการที่ตรงกับตัวเลือก", style: TextStyle(color: Colors.grey)),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  final history = filteredHistory[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Colors.blueAccent, size: 30),
                      title: Text(
                        history.book,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "📖 หน้า: ${history.page} \n⏳ เวลา: ${history.time} \n📅 วันที่: ${DateFormat('dd/MM/yyyy').format(history.dateRead)}"),
                      trailing: const Icon(Icons.play_arrow, color: Colors.green), // ✅ เพิ่มปุ่ม Play
                      onTap: () => _continueReading(history), // ✅ กดแล้วดึงข้อมูลกลับมาใช้
                    ),
                  );
                },
              ),
      ],
    ),
  );
}

}
