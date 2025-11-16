
import 'location_simple.dart';
import 'origin.dart';

/// Модель, представляющая персонажа из "Рика и Морти".
class Character {
  /// Уникальный идентификатор персонажа.
  final int id;
  /// Имя персонажа.
  final String name;
  /// Статус персонажа ('Alive', 'Dead' или 'unknown').
  final String status;
  /// Вид персонажа.
  final String species;
  /// Тип или подвид персонажа.
  final String type;
  /// Пол персонажа ('Female', 'Male', 'Genderless' или 'unknown').
  final String gender;
  /// Происхождение персонажа (имя и URL).
  final Origin origin;
  /// Последнее известное местоположение персонажа (имя и URL).
  final LocationSimple location;
  /// URL изображения персонажа.
  final String image;
  /// Список URL эпизодов, в которых появляется персонаж.
  final List<String> episode;
  /// URL специфичного endpoint персонажа.
  final String url;
  /// Дата создания персонажа в базе данных.
  final DateTime created;
  /// Локальное поле, указывающее, является ли персонаж избраным.
  bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
    // По умолчанию не в избранном
    this.isFavorite = false,
  });

  /// Конструктор для создания экземпляра из данных JSON API.
  /// [json]: Карта JSON, полученная от API.
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      origin: Origin.fromJson(json['origin'] as Map<String, dynamic>),
      location: LocationSimple.fromJson(json['location'] as Map<String, dynamic>),
      image: json['image'] as String,
      episode: (json['episode'] as List).cast<String>(),
      url: json['url'] as String,
      created: DateTime.parse(json['created'] as String),
      // Инициализируется как не избранный, база данных управляет остальным
      isFavorite: false,
    );
  }

  /// Метод для преобразования экземпляра в Map для вставки в базу данных.
  /// Возвращает [Map], готовую к вставке в базу данных sqflite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin_name': origin.name,
      'origin_url': origin.url,
      'location_name': location.name,
      'location_url': location.url,
      'image': image,
      // Сохранить список как строку, разделенную запятыми
      'episode': episode.join(','),
      'url': url,
      'created': created.toIso8601String(),
      // Сохранить как целое число (1 для true, 0 для false)
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  /// Конструктор для создания экземпляра из данных базы данных.
  /// [map]: Карта данных, полученная из базы данных sqflite.
  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      type: map['type'] as String,
      gender: map['gender'] as String,
      origin: Origin(name: map['origin_name'], url: map['origin_url']),
      location: LocationSimple(name: map['location_name'], url: map['location_url']),
      image: map['image'] as String,
      // Преобразовать строку обратно в список
      episode: (map['episode'] as String).split(','),
      url: map['url'] as String,
      created: DateTime.parse(map['created']),
      isFavorite: map['is_favorite'] == 1,
    );
  }
}