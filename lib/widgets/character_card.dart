
import 'package:flutter/material.dart';

import '../models/character.dart';
import '../l10n/app_localizations.dart';

/// Переиспользуемый виджет, отображающий детали персонажа в виде карточки.
/// Включает анимацию при переключении состояния избранного.
class CharacterCard extends StatefulWidget {
  /// Персонаж для отображения.
  final Character character;
  /// Колбэк, вызываемый при переключении состояния избранного персонажа пользователем.
  final Function(Character) onToggleFavorite;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onToggleFavorite,
  });

  @override
  State<CharacterCard> createState() => InitState();
}

class InitState extends State<CharacterCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Запускает анимацию переключения избранного.
  void _playAnimation() {
    _animationController.forward().then((_) => _animationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    // Получить экземпляр локализации для контекста
    final l10n = AppLocalizations.of(context);
    final character = widget.character;

    Widget cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: InkWell(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  character.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Отобразить изображение-заглушку при ошибке загрузки
                    return Image.asset(
                      'assets/images/placeholder.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n?.status ?? 'Status'}: ${character.status}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${l10n?.species ?? 'Species'}: ${character.species}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${l10n?.gender ?? 'Gender'}: ${character.gender}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${l10n?.location ?? 'Location'}: ${character.location.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                animation: Listenable.merge([_animationController]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: IconButton(
                        icon: Icon(
                          character.isFavorite ? Icons.star : Icons.star_border,
                          color: character.isFavorite ? Colors.orange : null,
                        ),
                        onPressed: () {
                          widget.onToggleFavorite(character);
                          // Проиграть анимацию
                          _playAnimation();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shadowColor: Theme.of(context).colorScheme.shadow,
      child: cardContent,
    );
  }
}