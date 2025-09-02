sealed class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class TimeoutFailure extends Failure {}

class UnauthorizedFailure extends Failure {}

class GeneralFailure extends Failure {}
