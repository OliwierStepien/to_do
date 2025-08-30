import 'package:to_do/common/failure.dart';

String mapFailureToMessage(Failure failure) {
  switch (failure) {
    case ServerFailure():
      return 'Ups, błąd API. Proszę spróbować ponownie!';
    case CacheFailure():
      return 'Ups, błąd lokalnego przechowywania danych. Proszę spróbować ponownie!';
    case TimeoutFailure():
      return 'Ups, przekroczono czas oczekiwania na odpowiedź. Proszę spróbować ponownie!';
    case UnauthorizedFailure():
      return 'Ups, nieautoryzowany dostęp. Zaloguj się ponownie!';
    case GeneralFailure():
      return 'Ups, coś poszło nie tak. Proszę spróbować ponownie!';
  }
}
