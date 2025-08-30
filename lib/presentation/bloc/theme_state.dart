import 'package:to_do/domain/theme/entity/theme_entity.dart';

/// Enum określający status naszego stanu.
/// Używamy go, żeby łatwo wiedzieć, w jakim trybie jest nasz BLoC/UI.
/// - initial: początkowy stan, nic się nie dzieje
/// - loading: dane są w trakcie pobierania lub zapisywania
/// - success: operacja zakończona sukcesem
/// - error: wystąpił błąd
enum ThemeStatus { initial, loading, success, error }

/// Klasa reprezentująca aktualny stan motywu.
/// Zawiera wszystkie dane, które mogą być potrzebne w UI.
class ThemeState {
  /// Status operacji (initial/loading/success/error)
  final ThemeStatus status;

  /// Opcjonalny komunikat o błędzie, jeśli status == error
  final String? errorMessage;

  /// Obiekt motywu, np. ThemeType.dark lub ThemeType.light
  final ThemeEntity? themeEntity;

  /// Prywatny konstruktor używany w fabrykach i copyWith
  ThemeState._({
    required this.status,
    this.errorMessage,
    this.themeEntity,
  });

  /// Fabryka tworząca początkowy stan
  /// Przy pierwszym uruchomieniu BLoC, status = initial, brak motywu i błędu
  factory ThemeState.initial() => ThemeState._(status: ThemeStatus.initial);

  /// copyWith pozwala utworzyć nową instancję ThemeState na podstawie istniejącej,
  /// zmieniając tylko te pola, które chcemy.
  /// Dzięki temu możemy aktualizować część stanu bez przepisywania wszystkiego.
  ThemeState copyWith({
    ThemeStatus? status,
    String? errorMessage,
    ThemeEntity? theme,
  }) {
    return ThemeState._(
      // jeśli podano nowy status, użyj go, inaczej zostaw obecny
      status: status ?? this.status,
      // jeśli podano nowy komunikat błędu, użyj go, inaczej zostaw obecny
      errorMessage: errorMessage ?? this.errorMessage,
      // jeśli podano nowy motyw, użyj go, inaczej zostaw obecny
      themeEntity: theme ?? themeEntity,
    );
  }
}