
import 'dart:convert';
import '../../models/character.dart';
import 'package:http/http.dart' as http;
import '../../models/character_response.dart';

/// Сервис для взаимодействия с REST API Rick and Morty.
class ApiService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';
  static const String _characterEndpoint = '$_baseUrl/character';

  /// Получает страницу персонажей из API.
  /// [page]: Номер страницы для получения (по умолчанию 1).
  /// Возвращает [CharacterResponse], содержащий информацию о пагинации и результаты.
  /// Выбрасывает [Exception] в случае ошибки сети или статуса HTTP, отличного от 200.
  Future<CharacterResponse> getCharacters({int page = 1}) async {
    try {
      final url = Uri.parse('$_characterEndpoint?page=$page');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CharacterResponse.fromJson(data);
      } else {
        throw Exception('Failed to load characters: ${response.statusCode}');
      }
    } catch (e) {
      // Передаёт ошибку дальше, чтобы виджет мог её перехватить
      rethrow;
    }
  }

  /// Получает конкретного персонажа по его ID из API.
  /// [id]: Уникальный идентификатор персонажа.
  /// Возвращает объект [Character].
  /// Выбрасывает [Exception] в случае ошибки сети или статуса HTTP, отличного от 200.
  Future<Character> getCharacter(int id) async {
    final url = Uri.parse('$_baseUrl/character/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Character.fromJson(data);
    } else {
      throw Exception('Failed to load character: ${response.statusCode}');
    }
  }

  /// Проверяет подключение к Интернету, выполняя HEAD-запрос к внешнему сайту.
  /// Возвращает `true`, если запрос успешен с кодом статуса 200, `false` в противном случае.
  Future<bool> isOnline() async {
    try {
      final result = await http.head(Uri.parse('https://www.google.com'));
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}