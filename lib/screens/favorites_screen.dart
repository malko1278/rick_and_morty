
import 'package:flutter/material.dart';

import '../models/character.dart';
import '../l10n/app_localizations.dart';
import '../widgets/character_card.dart';

enum SortOption { name, status, species }

/// Экран, отображающий список избранных персонажей.
/// Позволяет сортировать список по различным критериям.
class FavoritesScreen extends StatefulWidget {
  /// Список избранных персонажей для отображения.
  final List<Character> favorites;
  /// Колбэк, вызываемый при переключении состояния избранного для персонажа.
  final Function(Character) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<FavoritesScreen> createState() => InitState();
}

class InitState extends State<FavoritesScreen> {
  /// Текущая выбранная опция сортировки.
  SortOption _sortOption = SortOption.name;

  /// Возвращает список избранных, отсортированный по [_sortOption].
  List<Character> get _sortedFavorites {
    final sorted = List<Character>.from(widget.favorites);
    switch (_sortOption) {
      case SortOption.name:  sorted.sort((a, b) => a.name.compareTo(b.name));  break;
      case SortOption.status:  sorted.sort((a, b) => a.status.compareTo(b.status));  break;
      case SortOption.species:  sorted.sort((a, b) => a.species.compareTo(b.species));  break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    // Экземпляр локализации
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.favoritesTab ?? 'Favorites'),
        actions: <Widget>[
          PopupMenuButton<SortOption>(
            onSelected: (option) {
              _sortOption = option;
              setState(() {});
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortOption.name,
                child: Text(l10n?.sortByName ?? 'Name (A-Z)'),
              ),
              PopupMenuItem(
                value: SortOption.status,
                child: Text(l10n?.sortByStatus ?? 'Status'),
              ),
              PopupMenuItem(
                value: SortOption.species,
                child: Text(l10n?.sortBySpecies ?? 'Species'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _sortedFavorites.length,
        itemBuilder: (context, index) {
          final character = _sortedFavorites[index];
          return CharacterCard(
            character: character,
            onToggleFavorite: widget.onToggleFavorite,
          );
        },
      ),
    );
  }
}