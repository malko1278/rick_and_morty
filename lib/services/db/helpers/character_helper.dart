
import 'package:sqflite/sqflite.dart';

/// Вспомогательный класс, предоставляющий методы для выполнения базовых операций CRUD
/// над таблицей 'characters' локальной базы данных.
class CharacterHelper {
  // Приватный конструктор
  CharacterHelper._();
  // Одиночка
  static final CharacterHelper instance = CharacterHelper._();
  // Имя таблицы
  static const String tableName = 'characters';

  // Столбцы
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnStatus = 'status';
  static const String columnSpecies = 'species';
  static const String columnType = 'type';
  static const String columnGender = 'gender';
  static const String columnOriginName = 'origin_name';
  static const String columnOriginUrl = 'origin_url';
  static const String columnLocationName = 'location_name';
  static const String columnLocationUrl = 'location_url';
  static const String columnImage = 'image';
  // Хранится как строка, разделённая запятыми
  static const String columnEpisode = 'episode';
  static const String columnUrl = 'url';
  // Хранится как строка в формате ISO8601
  static const String columnCreated = 'created';
  // 0 или 1
  static const String columnIsFavorite = 'is_favorite';

  /// Создаёт таблицу 'characters' в базе данных.
  /// [db] : Экземпляр базы данных.
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnSpecies TEXT NOT NULL,
        $columnType TEXT,
        $columnGender TEXT,
        $columnOriginName TEXT,
        $columnOriginUrl TEXT,
        $columnLocationName TEXT,
        $columnLocationUrl TEXT,
        $columnImage TEXT NOT NULL,
        $columnEpisode TEXT, 
        $columnUrl TEXT NOT NULL,
        $columnCreated TEXT NOT NULL,
        $columnIsFavorite INTEGER DEFAULT 0
      )
    ''');
  }

  // --- Базовые операции CRUD (использующие Maps) ---

  /// Вставляет или обновляет персонажа (представленного как Map) в таблице.
  /// Если персонаж с таким же ID существует, он заменяется.
  /// [db] : Экземпляр базы данных.
  /// [characterMap] : Карта, представляющая персонажа для вставки/обновления.
  Future<void> upsertCharacterMap(Database db, Map<String, Object?> characterMap) async {
    await db.insert(
      tableName,
      characterMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Вставляет или обновляет несколько персонажей (представленных как Maps) в таблице.
  /// [db] : Экземпляр базы данных.
  /// [characterMaps] : Список карт, представляющих персонажей.
  Future<void> upsertCharactersMaps(Database db, List<Map<String, Object?>> characterMaps) async {
    final batch = db.batch();
    for (var map in characterMaps) {
      batch.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  /// Получает всех персонажей из таблицы.
  /// [db] : Экземпляр базы данных.
  /// [offset] : Смещение для пагинации (необязательно).
  /// [limit] : Ограничение количества результатов (необязательно).
  /// Возвращает список Maps, представляющих персонажей.
  Future<List<Map<String, Object?>>> getAllCharactersMap(Database db, {int? offset, int? limit}) async {
    return await db.query(
      tableName,
      offset: offset,
      limit: limit,
    );
  }

  /// Получает конкретного персонажа по его ID из таблицы.
  /// [db] : Экземпляр базы данных.
  /// [id] : Идентификатор персонажа.
  /// Возвращает Map, представляющую персонажа, если он найден, иначе `null`.
  Future<Map<String, Object?>?> getCharacterByIdMap(Database db, int id) async {
    final List<Map<String, Object?>> maps = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  /// Получает всех персонажей, помеченных как избранные, из таблицы.
  /// [db] : Экземпляр базы данных.
  /// Возвращает список Maps, представляющих избранных персонажей.
  Future<List<Map<String, Object?>>> getFavoriteCharactersMap(Database db) async {
    return await db.query(
      tableName,
      where: '$columnIsFavorite = ?',
      whereArgs: [1],
    );
  }

  /// Обновляет статус избранного для персонажа в таблице.
  /// [db] : Экземпляр базы данных.
  /// [id] : Идентификатор персонажа.
  /// [isFavorite] : Новый статус избранного (`true` или `false`).
  Future<void> updateFavoriteStatusMap(Database db, int id, bool isFavorite) async {
    await db.update(
      tableName,
      {columnIsFavorite: isFavorite ? 1 : 0},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  /// Удаляет конкретного персонажа по его ID из таблицы.
  /// [db] : Экземпляр базы данных.
  /// [id] : Идентификатор персонажа для удаления.
  Future<void> deleteCharacterByIdMap(Database db, int id) async {
    await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}