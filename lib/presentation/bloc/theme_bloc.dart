import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/theme/entity/theme_entity.dart';
import 'package:to_do/domain/theme/usecase/get_theme_usecase.dart';
import 'package:to_do/domain/theme/usecase/save_theme_usecase.dart';
import 'package:to_do/presentation/bloc/theme_events.dart';
import 'package:to_do/presentation/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeUsecase getThemeUsecase;
  final SaveThemeUsecase saveThemeUsecase;

  ThemeBloc({required this.getThemeUsecase, required this.saveThemeUsecase}) : super(ThemeState.initial()){
on<GetThemeEvent>(onGetThemeEvent);
on<ToggleThemeEvent>(onToggleThemeEvent);
  }


Future onGetThemeEvent(GetThemeEvent event, Emitter<ThemeState> emit) async {
  emit(state.copyWith(status: ThemeStatus.loading));
  try {
    final result = await getThemeUsecase();
    emit(state.copyWith(status: ThemeStatus.success, theme: result));
  } catch (e) {
    emit(state.copyWith(status: ThemeStatus.error, errorMessage: e.toString()));
  }
}
Future onToggleThemeEvent(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
  if (state.themeEntity != null){
    var newThemeType = state.themeEntity!.themeType == ThemeType.dark ? ThemeType.light : ThemeType.dark;
    var newThemeEntity = ThemeEntity(themeType: newThemeType);
    try {
      await saveThemeUsecase(newThemeEntity);
      emit(state.copyWith(status: ThemeStatus.success, theme: newThemeEntity));
    } catch (e) {
      emit(state.copyWith(status: ThemeStatus.error, errorMessage: e.toString()));
  }}
  }
}