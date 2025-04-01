enum RequestState {
  /// Request is not initialized
  notInitialized,

  /// Request is initialized
  initialized,

  /// Request is loading
  loading,

  /// Request is success
  success,

  /// Request is error
  error;

  /// Returns [true] if the [RequestState] is [notInitialized] or [initialized].
  bool get isNotInitialized => this == RequestState.notInitialized || this == RequestState.initialized;

  /// Returns [true] if the [RequestState] is [loading].
  bool get isLoading => this == RequestState.loading;

  /// Returns [true] if the [RequestState] is [success].
  bool get isSuccess => this == RequestState.success;

  /// Returns [true] if the [RequestState] is [error].
  bool get isError => this == RequestState.error;

  const RequestState();
}
