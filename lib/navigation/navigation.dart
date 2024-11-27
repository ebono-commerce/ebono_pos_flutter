
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:ebono_pos/ui/home/home_page.dart';
import 'package:ebono_pos/ui/login/login_page.dart';
import 'package:ebono_pos/ui/payment_summary/route/payment_summary_page.dart';
import 'package:ebono_pos/ui/payment_summary/route/print_receipt.dart';
import 'package:ebono_pos/ui/payment_summary/route/weight_display_page.dart';
import 'package:ebono_pos/ui/splash_screen/splash_screen.dart';

List<GetPage> getPages(){
  return  [
    GetPage(
        name: PageRoutes.splashScreen,
        page: () => SplashScreen()),
    GetPage(
        name: PageRoutes.login,
        page: () => LoginPage()),
    GetPage(
        name: PageRoutes.home,
        page: () => HomePage()),
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