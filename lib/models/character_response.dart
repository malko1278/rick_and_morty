
import 'info.dart';
import 'character.dart';

/// Модель, представляющая ответ API, содержащий несколько персонажей.
/// Этот ответ включает в себя информацию о пагинации и список персонажей.
class CharacterResponse {
  /// Информация о пагинации и общем количестве результатов.
  final Info info;
  /// Список полученных персонажей.
  final List<Character> results;

  CharacterResponse({
    required this.info,
    required this.results,
  });

  /// Создает экземпляр [CharacterResponse] из JSON-объекта.
  /// [json] : JSON-объект, полученный от API.
  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    final infoJson = json['info'] as Map<String, dynamic>;
    final resultsJson = json['results'] as List;
    return CharacterResponse(
      info: Info.fromJson(infoJson),
      results: resultsJson.map((e) => Character.fromJson(e)).toList(),
    );
  }
}