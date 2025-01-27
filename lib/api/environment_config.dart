class EnvironmentConfig {
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'prod');

  static String get baseUrl {
    switch (environment) {
      case 'prod':
        return "http://api-local.ebono.com/store/";
      case 'stage':
        return "http://api-local.ebono.com/store/";
      case 'dev':
      default:
        return "https://services-staging.ebono.com/store/";
    }
  }

  static String get paymentBaseUrl {
    switch (environment) {
      case 'prod':
        return "https://ezetap.com";
      case 'stage':
        return "https://demo.ezetap.com";
      case 'dev':
      default:
        return "https://demo.ezetap.com";
    }
  }

  static String get sseBaseUrl {
    switch (environment) {
      case 'prod':
        return "https://api.ebono.com/s/";
      case 'stage':
        return "https://api-staging.ebono.com/s/";
      case 'dev':
      default:
        return "https://api-staging.ebono.com/s/";
    }
  }
}
