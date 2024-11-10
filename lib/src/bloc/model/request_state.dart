enum RequestState {
  idle,
  loading,
  success,
  error;

  bool get isIdle => this == RequestState.idle;
  bool get isLoading => this == RequestState.loading;
  bool get isSuccess => this == RequestState.success;
  bool get isError => this == RequestState.error;
}