
/// Упрощённая модель для представления места (происхождения или локации)
/// в объекте [Character]. Содержит только имя и URL.
class LocationSimple {
  /// Название места.
  final String name;
  /// URL API-эндпоинта места.
  final String url;

  LocationSimple({
    required this.name,
    required this.url,
  });

  /// Создаёт экземпляр [LocationSimple] из JSON-карты.
  /// [json]: JSON-карта, полученная от API.
  factory LocationSimple.fromJson(Map<String, dynamic> json) {
    return LocationSimple(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}