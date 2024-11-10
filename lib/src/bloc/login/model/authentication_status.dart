enum AuthenticationStatus {
  authenticated,
  unauthenticated;

  bool get isAuthenticated => this == AuthenticationStatus.authenticated;

  bool get isUnauthenticated => this == AuthenticationStatus.unauthenticated;
}
