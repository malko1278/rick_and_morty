
/// Модель, представляющая информацию о пагинации и подсчете,
/// включенную в ответы API.
class Info {
  /// Общее количество документов, соответствующих запросу.
  final int count;
  /// Общее количество доступных страниц.
  final int pages;
  /// URL следующей страницы, если она существует, `null` в противном случае.
  final String? next;
  /// URL предыдущей страницы, если она существует, `null` в противном случае.
  final String? prev;

  Info({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  /// Создает экземпляр [Info] из JSON-карты.
  /// [json]: JSON-карта, полученная от API.
  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'] as int,
      pages: json['pages'] as int,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }
}