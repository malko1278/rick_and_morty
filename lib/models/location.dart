
/// Модель, представляющая полное местоположение из вселенной Рика и Морти.
/// Используется независимо от [Character], например, через API местоположений.
class Location {
  /// Уникальный идентификатор местоположения.
  final int id;
  /// Название местоположения.
  final String name;
  /// Тип местоположения (например, "Planet", "Space station").
  final String type;
  /// Измерение, в котором находится местоположение.
  final String dimension;
  /// Список URL-адресов персонажей, проживающих там (последнее известное местоположение).
  final List<String> residents;
  /// URL API-эндпоинта, специфичного для этого местоположения.
  final String url;
  /// Дата создания местоположения в базе данных API.
  final DateTime created;

  Location({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
  });

  /// Создает экземпляр [Location] из JSON-карты.
  /// [json] : JSON-карта, полученная от API.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      dimension: json['dimension'] as String,
      residents: (json['residents'] as List).cast<String>(),
      url: json['url'] as String,
      created: DateTime.parse(json['created'] as String),
    );
  }
}