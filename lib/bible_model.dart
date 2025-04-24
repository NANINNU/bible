class BibleBook {
  final int bibleId;
  final String title;
  final String shortTitle;

  BibleBook({
    required this.bibleId,
    required this.title,
    required this.shortTitle,
  });
}

class BibleVerse {
  final int bibleId;
  final int chapter;
  final int verse;
  final String script;
  bool isFavorite;
  String highlightColor;

  BibleVerse({
    required this.bibleId,
    required this.chapter,
    required this.verse,
    required this.script,
    this.isFavorite = false,
    this.highlightColor = '',
  });
}