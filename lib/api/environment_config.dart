class EnvironmentConfig {
  static const String environment =
      String.fromEnvironment('ENV', defaultValue: 'stage');

  static String get baseUrl {
    switch (environment) {
      case 'prod':
        // return "http://api-local.ebono.com/store/";
        return bffUrl;
      case 'stage':
        return "http://api-local.ebono.com/store/";
      case 'dev':
      case 'uat':
      default:
        return bffUrl;
    }
  }

  static String get bffUrl {
    switch (environment) {
      case 'prod':
        return 'https://api.ebono.com/s/';
      case 'stage':
        return 'https://api-staging.ebono.com/s/';
      case 'uat':
        return 'https://api-uat.ebono.com/s/';
      default:
        return 'https://api-staging.ebono.com/s/';
    }
  }

  static String get paymentBaseUrl {
    switch (environment) {
      case 'prod':
        return "https://ezetap.com";
      case 'stage':
        return "https://demo.ezetap.com";
      case 'dev':
        return "https://demo.ezetap.com";
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
        return "https://api-staging.ebono.com/s/";
      default:
        return "https://api-staging.ebono.com/s/";
    }
  }
}
