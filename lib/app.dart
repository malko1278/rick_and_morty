import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rick_and_morty/screens/home_screen.dart';
import 'package:rick_and_morty/screens/favorites_screen.dart';
import 'package:rick_and_morty/services/api/api_service.dart';
import 'package:rick_and_morty/services/db/controllers/character_controller.dart';

import 'l10n/app_localizations.dart';
import 'models/character.dart';

final GlobalKey<AppState> appStateKey = GlobalKey<AppState>();

/// Главный виджет приложения.
/// Управляет глобальным состоянием: темой, навигацией, загрузкой, данными (персонажи, избранное),
/// и подключением к API/локальному хранилищу.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  final CharacterController _dbController = CharacterController();
  final ApiService _apiService = ApiService();
  late List<Character> _allCharacters = [];
  late List<Character> _favoriteCharacters = [];
  late bool _isLoading = true;
  late bool _isLoadingMore = false;
  late bool _hasMore = true;
  late int _currentPage = 1;
  late bool _isOnline = false;
  // Состояние темы
  late bool _darkTheme = false;
  // Переменная состояния для навигации
  late int _selectedIndex = 0;

  /// Глобальное сообщение об ошибке при инициализации.
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    // Загрузить предпочтение темы при запуске
    _loadThemePreference();
    initializeApp();
  }

  /// Загружает пользовательское предпочтение для темной/светлой темы.
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool('dark_theme') ?? false;
    setState(() {});
  }

  /// Инициализирует приложение: загружает избранное, проверяет подключение,
  /// и получает начальные персонажи.
  Future<void> initializeApp() async {
    _isLoading = true;
    // Сбросить ошибку в начале
    _initializationError = null;
    setState(() {});

    _isOnline = await _apiService.isOnline();
    try {
      // Загрузить избранное из базы данных через контроллер
      _favoriteCharacters = await _dbController.getFavoriteCharacters();
      // Обновить состояние isFavorite для персонажей, загруженных локально
      for (var char in _allCharacters) {
        char.isFavorite = _favoriteCharacters.any((fav) => fav.id == char.id);
      }
      // Если онлайн, загрузить данные из API
      if (_isOnline) {
        await _fetchCharacters();
      } else {
        // Загрузить данные из базы данных через контроллер
        _allCharacters = await _dbController.getCharacters();
        // Обновить состояние isFavorite
        for (var char in _allCharacters) {
          char.isFavorite = _favoriteCharacters.any((fav) => fav.id == char.id);
        }
        // Нет пагинации оффлайн
        _hasMore = false;
      }
    } catch (e) {
      // Обработать ошибку (показать сообщение, загрузить резервные данные и т.д.)
      // print("Error initializing app: $e");
      _initializationError = e.toString(); // Сохранить сообщение об ошибке
      // Загрузить локальные данные даже при ошибке сети
      try {
        _allCharacters = await _dbController.getCharacters();
        for (var char in _allCharacters) {
          char.isFavorite = _favoriteCharacters.any((fav) => fav.id == char.id);
        }
        _hasMore = false;
      } catch (localError) {
        // print("Error loading local  $localError");
        _initializationError = "Error loading local  $localError";
      }
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  /// Получает следующую страницу персонажей из API и кэширует её.
  Future<void> _fetchCharacters() async {
    // Предотвратить множественные вызовы
    if (_isLoadingMore || !_hasMore) return;
    setState(() { _isLoadingMore = true; });
    try {
      final response = await _apiService.getCharacters(page: _currentPage);
      final newCharacters = response.results;
      // Обновить состояние isFavorite для новых загруженных персонажей
      for (var char in newCharacters) {
        char.isFavorite = _favoriteCharacters.any((fav) => fav.id == char.id);
      }
      _allCharacters.addAll(newCharacters);
      _currentPage++;
      _hasMore = response.info.next != null;
      setState(() {});
      // Кэшировать новые персонажи
      await _dbController.upsertCharacters(newCharacters);
    } catch (e) {
      // print("Error fetching characters: $e");
      // Проверить, что виджет всё ещё подключен
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          // Показать SnackBar с сообщением об ошибке
          SnackBar(
            content: Text('Failed to load more characters: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.retry,
              // Повторить попытку
              onPressed: _fetchCharacters,
            ),
          ),
        );
      }
    } finally {
      setState(() { _isLoadingMore = false; });
    }
  }

  /// Переключает статус избранного для персонажа и обновляет базу данных.
  Future<void> toggleFavorite(Character character) async {
    setState(() {
      character.isFavorite = !character.isFavorite;
    });
    await _dbController.updateFavoriteStatus(character.id, character.isFavorite);
    if (character.isFavorite) {
      _favoriteCharacters.add(character);
    } else {
      _favoriteCharacters.removeWhere((fav) => fav.id == character.id);
    }
  }

  /// Переключает между темной и светлой темой.
  void _toggleTheme() {
    _darkTheme = !_darkTheme;
    setState(() {});
    _saveThemePreference();
  }

  /// Сохраняет пользовательское предпочтение темы.
  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_theme', _darkTheme);
  }

  @override
  Widget build(BuildContext context) {
    // Получить экземпляр перевода для контекста
    final l10n = AppLocalizations.of(context);

    Widget bodyWidget;
    if (_isLoading) {
      bodyWidget = const Center(child: CircularProgressIndicator());
    } else if (_initializationError != null) {
      // Отобразить виджет ошибки, если инициализация не удалась
      bodyWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to initialize app',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _initializationError!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // Повторить инициализацию
              onPressed: initializeApp,
              child: Text(l10n?.retry ?? 'Retry'),
            ),
          ],
        ),
      );
    } else {
      // Отобразить нормальные экраны
      bodyWidget = IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            characters: _allCharacters,
            isLoadingMore: _isLoadingMore,
            hasMore: _hasMore,
            onLoadMore: _fetchCharacters,
            onToggleFavorite: toggleFavorite,
            isOnline: _isOnline,
          ),
          FavoritesScreen(
            favorites: _favoriteCharacters,
            onToggleFavorite: toggleFavorite,
          ),
        ],
      );
    }

    return MaterialApp(
      title: 'Rick and Morty App',
      // Светлая тема по умолчанию
      theme: ThemeData.light(),
      // Темная тема
      darkTheme: ThemeData.dark(),
      // Применить активную тему
      themeMode: _darkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        key: appStateKey,
        appBar: AppBar(
          // Используйте перевод для заголовка
          title: Text(l10n?.appName ?? 'Rick and Morty App'),
          actions: <Widget>[
            IconButton(
              icon: Icon(_darkTheme ? Icons.light_mode : Icons.dark_mode),
              // Действие для переключения темы
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: bodyWidget,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 8.0,
          currentIndex: _selectedIndex,
          onTap: (index) {
            _selectedIndex = index;
            setState(() {});
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: l10n?.homeTab ?? 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.star),
              label: l10n?.favoritesTab ?? 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}