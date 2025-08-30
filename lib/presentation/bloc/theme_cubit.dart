import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/domain/theme/usecase/get_theme_usecase.dart';
import 'package:to_do/domain/theme/usecase/save_theme_usecase.dart';
import 'package:to_do/presentation/bloc/theme_state.dart';

/// Cubit obsługujący stan motywu
class ThemeCubit extends Cubit<ThemeState> {
  final GetThemeUsecase getThemeUsecase;
  final SaveThemeUsecase saveThemeUsecase;

  ThemeCubit({required this.getThemeUsecase, required this.saveThemeUsecase})
    : super(ThemeState.initial());

  /// Pobiera aktualny motyw
  Future<void> getTheme() async {
    emit(state.copyWith(status: ThemeStatus.loading));

    try {
      final result = await getThemeUsecase();

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: ThemeStatus.error,
            errorMessage: failure
                .toString(), // Możesz tu użyć mapFailureToMessage(failure)
          ),
        ),
        (themeEntity) => emit(
          state.copyWith(status: ThemeStatus.success, theme: themeEntity),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ThemeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  /// Przełącza motyw (dark <-> light)
  Future<void> toggleTheme() async {
    if (state.themeEntity != null) {
      final newThemeType = state.themeEntity!.themeType == ThemeType.dark
          ? ThemeType.light
          : ThemeType.dark;

      final newThemeEntity = ThemeEntity(themeType: newThemeType);

      try {
        await saveThemeUsecase(newThemeEntity);
        emit(
          state.copyWith(status: ThemeStatus.success, theme: newThemeEntity),
        );
      } catch (e) {
        emit(
          state.copyWith(status: ThemeStatus.error, errorMessage: e.toString()),
        );
      }
    }
  }
}
