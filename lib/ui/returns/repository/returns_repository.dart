import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/ui/returns/models/order_items_model.dart';
import 'package:ebono_pos/ui/returns/models/refund_success_model.dart';

import '../../../api/api_exception.dart';

class ReturnsRepository {
  final ApiHelper _apiHelper;
  final HomeController _homeController;

  ReturnsRepository(this._apiHelper, this._homeController);

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
    required bool isStoreOrder,
  }) async {
    try {
      final queryParams = isStoreOrder
          ? '?is_store_order=true&outlet_id=${_homeController.selectedOutletId}'
          : '';

      final response = await _apiHelper.get(
        "${ApiConstants.orders}/$orderId$queryParams",
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
