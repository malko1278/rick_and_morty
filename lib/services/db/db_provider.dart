
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'helpers/character_helper.dart';

/// Единственный провайдер локальной базы данных SQLite.
/// Управляет инициализацией и доступом к экземпляру базы данных.
class DbProvider {
  // Приватный конструктор для предотвращения прямой инстанциации
  DbProvider._();
  // Единственный экземпляр (синглтон)
  static final DbProvider instance = DbProvider._();
  static Database? _database;

  /// Возвращает единственный экземпляр базы данных.
  /// Если экземпляр еще не существует, он инициализируется через [_initDatabase].
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Инициализирует базу данных SQLite.
  /// Создает файл базы данных и вызывает [_onCreate], если это первый запуск.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'rick_and_morty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Этот метод вызывается при первоначальном создании базы данных.
  /// Используется для создания необходимых таблиц.
  /// [db] : Экземпляр базы данных.
  /// [version] : Версия базы данных.
  Future<void> _onCreate(Database db, int version) async {
    // Таблицы создаются через соответствующий хелпер.
    // Здесь вызывается хелпер для таблицы персонажей.
    await CharacterHelper.instance.createTable(db);
    // Если добавляются другие таблицы, вызовите их методы создания здесь.
    // Пример: await LocationTableHelper.instance.createTable(db);
  }
}