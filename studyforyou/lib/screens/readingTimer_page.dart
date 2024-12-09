import 'dart:async';
import 'package:flutter/material.dart';
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
  final List<ReadingHistory> _readingHistory = [];
  int _totalReadingTimeInSeconds = 0;
  final TextEditingController _bookController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();

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
      _readingHistory.insert(
          0,
          ReadingHistory(
              book: _bookController.text, page: page, time: formattedTime));
      _bookController.clear();
      _pageController.clear();
    });

    _stopwatch.reset();
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
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
                child: const Text("ยกเลิก")),
            TextButton(
                onPressed: () {
                  _addToHistory();
                  Navigator.of(context).pop();
                },
                child: const Text("บันทึก")),
          ],
        );
      },
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "เวลาอ่าน: $hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 30),
            TextField(
                controller: _bookController,
                decoration: const InputDecoration(
                    labelText: 'ชื่อหนังสือ', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: !_isRunning ? _startStopwatch : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15)),
                    child: const Text(
                      "เริ่มจับเวลา",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? _stopStopwatch : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15)),
                  child: const Text("หยุดจับเวลา"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("ประวัติการอ่าน:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _readingHistory.length,
                itemBuilder: (context, index) {
                  final history = _readingHistory[index];
                  return ListTile(
                    title: Text(
                        "ชื่อหนังสือ: ${history.book} - หน้า: ${history.page} \nเวลา: ${history.time}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
