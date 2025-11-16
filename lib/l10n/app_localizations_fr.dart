// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Rick et Morty App';

  @override
  String get homeTab => 'Accueil';

  @override
  String get favoritesTab => 'Favoris';

  @override
  String get status => 'Statut';

  @override
  String get species => 'Espèce';

  @override
  String get gender => 'Genre';

  @override
  String get location => 'Lieu';

  @override
  String get origin => 'Origine';

  @override
  String get sortBy => 'Trier Par';

  @override
  String get sortByName => 'Nom (A-Z)';

  @override
  String get sortByStatus => 'Statut';

  @override
  String get sortBySpecies => 'Espèce';

  @override
  String get errorLoadingCharacters => 'Erreur de chargement des personnages.';

  @override
  String get noInternet => 'Aucune connexion internet. Affichage des données mises en cache.';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Réessayer';

  @override
  String get failedToInitializeApp => 'Échec de l\'initialisation de l\'application';

  @override
  String get failedToLoadLocalCharacters => 'Erreur de chargement des données locales.';
}
