class ApiConstants {
  static final baseUrl = 'https://services-staging.kpnfresh.com/store/';
  //static final baseUrl = 'https://192.168.0.187:80/';
  static final login = 'authn/v1/login';
  static final logout = 'authn/v1/logout';
  static final outletDetails = 'pos/v1/outlets/';
  static final terminalDetails = '/pos/v1/terminal-selection?';
  static final fetchCart = 'checkout/v1/cart/fetch?schema=DETAIL';
  static final fetchCustomer = 'account/v1/customer/fetch';
  static final getCustomerDetails = 'account/v1/customer';
  static final scanProducts = 'catalog/v1/products/scan';
}
