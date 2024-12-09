class ReadingHistory {
  final String book;
  final int page;
  final String time;

  ReadingHistory({
    required this.book,
    required this.page,
    required this.time,
  });

  Map<String, String> toMap() {
    return {
      'book': book,
      'page': page.toString(),
      'time': time,
    };
  }
}
