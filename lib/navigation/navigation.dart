
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';
import 'package:kpn_pos_application/ui/home/home_page.dart';
import 'package:kpn_pos_application/ui/login/login_page.dart';
import 'package:kpn_pos_application/ui/payment_summary/route/payment_summary_page.dart';
import 'package:kpn_pos_application/ui/payment_summary/route/print_receipt.dart';
import 'package:kpn_pos_application/ui/payment_summary/route/weight_display_page.dart';
import 'package:kpn_pos_application/vm/home_vm.dart';

List<GetPage> getPages(){
  return  [
    GetPage(
        name: PageRoutes.login,
        page: () => LoginPage()),
    GetPage(
        name: PageRoutes.home,
        page: () => HomePage(homeViewModel: HomeViewModel())),
    GetPage(
        name: PageRoutes.paymentSummary,
        page: () => PaymentSummaryScreen()),
    GetPage(
        name: PageRoutes.printReceipt,
        page: () => PrintReceiptPage()),
    GetPage(
        name: PageRoutes.weightDisplay,
        page: () => WeightDisplayPage()),
  ];
}