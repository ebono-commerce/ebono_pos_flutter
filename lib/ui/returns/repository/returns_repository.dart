import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/ui/returns/models/order_items_model.dart';

class ReturnsRepository {
  final ApiHelper _apiHelper;

  ReturnsRepository(this._apiHelper);

  Future<List<CustomerOrderDetails>> fetchCustomerOrderDetails({
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiHelper.get(
        "https://bs6kbvfh-3000.inc1.devtunnels.ms/api/v1/pos/orders?phone_number=$phoneNumber",
      );

      List<dynamic> customerOrdersList = response['orders'];

      List<CustomerOrderDetails> data = customerOrdersList
          .map((order) => CustomerOrderDetails.fromJSON(order))
          .toList();

      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<OrderItemsModel> fetchOrderItemBasedOnOrderId({
    required String orderId,
  }) async {
    try {
      final response = await _apiHelper.get(
        "https://bs6kbvfh-3000.inc1.devtunnels.ms/api/v1/pos/orders/$orderId",
      );

      OrderItemsModel data = OrderItemsModel.fromJSON(response);

      return data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
