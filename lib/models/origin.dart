
/// Модель, представляющая происхождение персонажа.
/// Содержит имя и URL происхождения.
class Origin {
  /// Имя происхождения (например, "Earth (C-137)").
  final String name;
  /// URL API-эндпоинта происхождения.
  final String url;

  Origin({
    required this.name,
    required this.url,
  });

  /// Создает экземпляр [Origin] из JSON-карты.
  /// [json]: JSON-карта, полученная от API.
  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}