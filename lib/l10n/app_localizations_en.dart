// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rick and Morty App';

  @override
  String get homeTab => 'Home';

  @override
  String get favoritesTab => 'Favorites';

  @override
  String get status => 'Status';

  @override
  String get species => 'Species';

  @override
  String get gender => 'Gender';

  @override
  String get location => 'Location';

  @override
  String get origin => 'Origin';

  @override
  String get sortBy => 'Sort By';

  @override
  String get sortByName => 'Name (A-Z)';

  @override
  String get sortByStatus => 'Status';

  @override
  String get sortBySpecies => 'Species';

  @override
  String get errorLoadingCharacters => 'Error loading characters.';

  @override
  String get noInternet => 'No internet connection. Showing cached data.';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Retry';

  @override
  String get failedToInitializeApp => 'Failed to initialize app';

  @override
  String get failedToLoadLocalCharacters => 'Error loading local data.';
}
