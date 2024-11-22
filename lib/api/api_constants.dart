class ApiConstants {
  static final baseUrl = 'https://services-staging.kpnfresh.com/store/';
  //static final baseUrl = 'https://192.168.0.187:80/';
  static final login = 'authn/api/v1/pos/login';
  static final logout = 'authn/api/v1/pos/logout';
  static final outletDetails = 'account/api/v1/pos/outlets/';
  static final terminalDetails = 'account/api/v1/pos/terminal-selection';
  static final fetchCart = 'checkout/api/v1/pos/cart/fetch?schema=DETAIL';
  static final fetchCustomer = 'account/api/v1/pos/customer/fetch';
  static final getCustomerDetails = 'account/api/v1/pos/customer';
  static final scanProducts = 'catalog/api/v1/pos/products/scan';
  static final addToCart = 'checkout/api/v1/pos/cart/';
  static final deleteFromCart = 'checkout/api/v1/pos/cart/';
  static final updateCart = 'checkout/api/v1/pos/cart/';

  static final holdCart = 'checkout/api/v1/pos/cart/';
  static final clearFullCart = 'checkout/api/v1/pos/cart/';
}
