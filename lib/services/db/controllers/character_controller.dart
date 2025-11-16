
import '../db_provider.dart';
import '../../../models/character.dart';
import '../helpers/character_helper.dart';

/// Контроллер для управления операциями CRUD с персонажами в локальной базе данных.
class CharacterController {
  final DbProvider _dbProvider = DbProvider.instance;
  final CharacterHelper _helper = CharacterHelper.instance;

  /// --- Публичные операции CRUD (использующие объекты Character) ---

  /// Вставляет или обновляет персонажа в базе данных.
  /// [character] : Объект [Character], который нужно вставить или обновить.
  Future<void> upsertCharacter(Character character) async {
    final db = await _dbProvider.database;
    await _helper.upsertCharacterMap(db, character.toMap());
  }

  /// Вставляет или обновляет несколько персонажей в базе данных.
  /// [characters] : Список объектов [Character], которые нужно вставить или обновить.
  Future<void> upsertCharacters(List<Character> characters) async {
    final db = await _dbProvider.database;
    final maps = characters.map((c) => c.toMap()).toList();
    await _helper.upsertCharactersMaps(db, maps);
  }

  /// Получает всех персонажей из базы данных.
  /// [offset] : Смещение для пагинации (опционально).
  /// [limit] : Ограничение количества результатов (опционально).
  /// Возвращает список [Character].
  Future<List<Character>> getCharacters({int? offset, int? limit}) async {
    final db = await _dbProvider.database;
    final maps = await _helper.getAllCharactersMap(db, offset: offset, limit: limit);
    return maps.map((map) => Character.fromMap(map)).toList();
  }

  /// Получает конкретного персонажа по его ID из базы данных.
  /// [id] : Уникальный идентификатор персонажа.
  /// Возвращает объект [Character], если он найден, или `null`, если не найден.
  Future<Character?> getCharacterById(int id) async {
    final db = await _dbProvider.database;
    final map = await _helper.getCharacterByIdMap(db, id);
    return map != null ? Character.fromMap(map) : null;
  }

  /// Получает всех персонажей, помеченных как избранные в базе данных.
  /// Возвращает список [Character], у которых `isFavorite` установлен в `true`.
  Future<List<Character>> getFavoriteCharacters() async {
    final db = await _dbProvider.database;
    final maps = await _helper.getFavoriteCharactersMap(db);
    // Убедитесь, что isFavorite установлен в true
    return maps.map((map) => Character.fromMap(map)..isFavorite = true).toList();
  }

  /// Обновляет статус избранного для персонажа в базе данных.
  /// [id] : Идентификатор персонажа.
  /// [isFavorite] : Новый статус избранного (`true` или `false`).
  Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    final db = await _dbProvider.database;
    await _helper.updateFavoriteStatusMap(db, id, isFavorite);
  }

  /// Удаляет конкретного персонажа по его ID из базы данных.
  /// [id] : Идентификатор персонажа для удаления.
  /// Этот метод является необязательным.
  Future<void> deleteCharacterById(int id) async {
    final db = await _dbProvider.database;
    await _helper.deleteCharacterByIdMap(db, id);
  }

  /// Закрывает соединение с базой данных.
  /// Этот метод является необязательным, sqflite обычно управляет закрытием самостоятельно.
  Future<void> close() async {
    final db = await _dbProvider.database;
    await db.close();
  }
}