
import 'package:flutter/material.dart';

import '../app.dart';
import '../models/character.dart';
import '../l10n/app_localizations.dart';
import '../widgets/character_card.dart';

/// Экран домашней страницы, отображающий пагинированный список персонажей.
class HomeScreen extends StatefulWidget {
  final List<Character> characters;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Function(Character) onToggleFavorite;
  final bool isOnline;

  const HomeScreen({
    super.key,
    required this.characters,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
    required this.onToggleFavorite,
    required this.isOnline,
  });

  @override
  State<HomeScreen> createState() => InitState();
}

class InitState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Обработчик прокрутки для загрузки дополнительных персонажей.
  void _onScroll() {
    if (_isScrollAtEnd(_scrollController) && widget.hasMore && !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  /// Проверяет, находится ли прокрутка вблизи конца списка.
  bool _isScrollAtEnd(ScrollController controller) {
    if (!controller.hasClients) return false;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    // Триггер при 90% прокрутки
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    // Получить экземпляр локализации для текущего контекста
    final l10n = AppLocalizations.of(context);

    // Отобразить сообщение, если нет подключения к интернету
    if (!widget.isOnline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.noInternet ?? 'No internet connection. Showing cached data.'),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Сбросить и повторно загрузить данные из API
        // Это будет зависеть от вашей логики инициализации в App
        // Например, вы можете вызвать метод в App через InheritedWidget или Provider
        // На данный момент мы сбрасываем локальное состояние и перезагружаем
        // setState в App управляется логикой инициализации
        if (mounted) {
          // Использовать глобальный ключ для доступа к состоянию App
          final appState = appStateKey.currentState;
          // Сбросить приложение через ключ, если appState != null
          if (appState != null)   appState.initializeApp();
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.characters.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.characters.length) {
            // Отобразить индикатор загрузки внизу, если идет загрузка дополнительных данных
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final character = widget.characters[index];
          return CharacterCard(
            character: character,
            onToggleFavorite: widget.onToggleFavorite,
          );
        },
      ),
    );
  }
}