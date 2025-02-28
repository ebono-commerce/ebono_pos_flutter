import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/ui/returns/models/order_items_model.dart';
import 'package:ebono_pos/ui/returns/models/refund_success_model.dart';

import '../../../api/api_exception.dart';

class ReturnsRepository {
  final ApiHelper _apiHelper;

  ReturnsRepository(this._apiHelper);

  Future<CustomerOrders> fetchCustomerOrderDetails({
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiHelper.get(
        "${ApiConstants.orders}?phone_number=$phoneNumber",
      );

      CustomerOrders data = CustomerOrders.fromJSON(response);

      return data;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<OrderItemsModel> fetchOrderItemBasedOnOrderId({
    required String orderId,
  }) async {
    try {
      final response = await _apiHelper.get(
        "${ApiConstants.orders}/$orderId",
      );

      OrderItemsModel data = OrderItemsModel.fromJSON(response);

      return data;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<RefundSuccessModel> proceedToReturnItems({
    required OrderItemsModel refundItems,
  }) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.returnOrders,
        data: refundItems.toReturnPostReqJSON(),
      );

      var apiResponse = RefundSuccessModel.fromJson(response).copyWith(
        totalItems: refundItems.orderLines!.length.toString(),
      );

      return apiResponse;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
