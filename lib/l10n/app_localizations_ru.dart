// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Рик и Морти Апп';

  @override
  String get homeTab => 'Главная';

  @override
  String get favoritesTab => 'Избранное';

  @override
  String get status => 'Статус';

  @override
  String get species => 'Вид';

  @override
  String get gender => 'Пол';

  @override
  String get location => 'Местоположение';

  @override
  String get origin => 'Происхождение';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get sortByName => 'Имя (А-Я)';

  @override
  String get sortByStatus => 'Статус';

  @override
  String get sortBySpecies => 'Вид';

  @override
  String get errorLoadingCharacters => 'Ошибка загрузки персонажей.';

  @override
  String get noInternet => 'Нет подключения к интернету. Отображаются кэшированные данные.';

  @override
  String get ok => 'ОК';

  @override
  String get retry => 'Повторить';

  @override
  String get failedToInitializeApp => 'Не удалось инициализировать приложение';

  @override
  String get failedToLoadLocalCharacters => 'Ошибка загрузки локальных данных.';
}
