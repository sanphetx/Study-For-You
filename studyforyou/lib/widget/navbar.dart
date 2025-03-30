import 'package:flutter/material.dart';
import 'package:studyforyou/screens/library_page.dart';
import 'package:studyforyou/screens/readingTimer_page.dart';
import 'package:studyforyou/screens/addform.dart';

class NavBar extends StatelessWidget {
  final VoidCallback onAddNote;

  const NavBar({super.key, required this.onAddNote});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 12.0,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.library_books, color: Colors.black54),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LibraryPage()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.timer, color: Colors.black54),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ReadingTimerPage()),
                  ),
                ),
                const SizedBox(width: 60), // เว้นที่สำหรับ FAB
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black54),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.black54),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),

        // Floating Action Button (FAB)
        Positioned(
          top: -30,
          child: FloatingActionButton(
            onPressed: onAddNote,
            backgroundColor: Colors.pinkAccent,
            child: const Icon(Icons.add, color: Colors.white, size: 30),
            shape: const CircleBorder(),
            elevation: 8,
          ),
        ),
      ],
    );
  }
}
