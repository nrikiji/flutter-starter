class Environment {
  final EnvironmentKind kind;
  final String baseApiUrl;

  factory Environment() {
    const env = String.fromEnvironment('env');
    return env == 'prod' ? Environment.prod() : Environment.dev();
  }

  const Environment._({
    required this.kind,
    required this.baseApiUrl,
  });

  const Environment.prod()
      : this._(
          kind: EnvironmentKind.Prod,
          baseApiUrl: "https://example.com",
        );

  const Environment.dev()
      : this._(
          kind: EnvironmentKind.Dev,
          baseApiUrl: "https://dev.example.com",
        );
}

enum EnvironmentKind {
  Dev,
  Prod,
}
