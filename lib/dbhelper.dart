import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'bible_model.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'bible.db');

    final exists = await File(path).exists();

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "bible.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path, readOnly: false);
  }

  Future<List<BibleBook>> getBibleBooks(int ab) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bibleIndex',
      where: 'AB = ?',
      whereArgs: [ab],
    );
    return List.generate(maps.length, (i) {
      return BibleBook(
        bibleId: maps[i]['bibleID'],
        title: maps[i]['title'],
        shortTitle: maps[i]['shortTitle'],
      );
    });
  }

  Future<List<BibleVerse>> getVerses(int bibleId, int chapter) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bible',
      where: 'bibleID = ? AND chapter = ?',
      whereArgs: [bibleId, chapter],
    );
    return List.generate(maps.length, (i) {
      return BibleVerse(
        bibleId: maps[i]['bibleID'],
        chapter: maps[i]['chapter'],
        verse: maps[i]['verse'],
        script: maps[i]['script'],
        isFavorite: false, // 즐겨찾기 기능 구현 필요
        highlightColor: '', // 하이라이트 기능 구현 필요
      );
    });
  }

  Future<void> updateVerse(BibleVerse verse) async {
    // 즐겨찾기 및 하이라이트 기능 구현 필요
  }
}