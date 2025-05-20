class EnvironmentConfig {
  static const String environment =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  static String get baseUrl {
    switch (environment) {
      case 'prod':
        return "http://api-local.ebono.com/store/";
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
      case 'uat':
        return 'https://api-uat.ebono.com/s/';
      case 'stage':
      case 'dev':
      default:
        return 'https://api-staging.ebono.com/s/';
    }
  }

  static String get ezetapBaseUrl {
    switch (environment) {
      case 'prod':
        return "https://ezetap.com";
      case 'stage':
      case 'dev':
      default:
        return "https://demo.ezetap.com";
    }
  }

  static String get paytmBaseUrl {
    switch (environment) {
      case 'prod':
      return "https://securegw-edc.paytm.in/";
      case 'stage':
      case 'dev':
      default:
        return "https://securegw-stage.paytm.in/";
    }
  }

  static String get sseBaseUrl {
    switch (environment) {
      case 'prod':
        return "https://api.ebono.com/s/";
      case 'stage':
      case 'dev':
      default:
        return "https://api-staging.ebono.com/s/";
    }
  }
}
