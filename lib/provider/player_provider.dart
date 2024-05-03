import 'package:sqflite/sqflite.dart';

import '../models/player.dart';

class PlayerProvider {
  PlayerProvider({
    required this.dbPath,
    required this.dbVersion
  });

  final String dbPath;
  final int dbVersion;
  Database? db;

  Future<Database?> get ready async {
    if (db == null) {
      await _open();
    }
    return db;
  }

  Future _open() async {
    db = await openDatabase(
      dbPath,
      version: dbVersion,
      onCreate: (db, version) async {
        await _createDb(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await _createDb(db);
        }
      },
    );
  }

  Future insertPlayer(Player player) async {
    await db!.insert(
      'player',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort
    );
  }

  Future<List<Player>> getPlayers() async {
    final List<Map<String, Object?>> playerMaps = await db!.query('player');
    return [
      for (final {
        'id': id as int,
        'currLevel': currLevel as int,
        'unlockedLevelCount': unlockedLevelCount as int
      } in playerMaps)
      Player(id: id, currLevel: currLevel, unlockedLevelCount: unlockedLevelCount)
    ];
  }

  Future<void> updatePlayer(Player player) async {
    await db!.update(
      'player',
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id]
    );
  }

  Future<void> deletePlayer(int id) async {
    await db!.delete(
      'player',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future _createDb(Database db) async {
    await db.execute(
      '''
        CREATE TABLE player(
          id INTEGER PRIMARY KEY,
          currLevel INTEGER,
          unlockedLevelCount INTEGER
        )
      '''
    );
  }

  Future deleteAll() async {
    await db!.execute('DELETE FROM player');
  }

  Future close() async {
    await db!.close();
  }
}