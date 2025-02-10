import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/models/scan_products_response.dart';

class SearchRepository {
  final ApiHelper _apiHelper;

  SearchRepository(this._apiHelper);

  Future<List<ScanProductsResponse>> searchItems(
      {required String searchText}) async {
    try {
      final response =
          await _apiHelper.get(ApiConstants.searchItems(searchText));

      List<ScanProductsResponse> searchItemsList = (response as List)
          .map((searchItem) => ScanProductsResponse.fromJson(searchItem))
          .cast<ScanProductsResponse>()
          .toList();

      return searchItemsList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
