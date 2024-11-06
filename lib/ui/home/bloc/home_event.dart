abstract class HomeEvent {}

/*
"phone_number": "8871722186",
"cart_type": "POS",
"outlet_id": "OCHNMYL01"
*/

class FetchCustomer extends HomeEvent {
  final String phoneNumber;
  final String cartType;
  final String outletId;

  FetchCustomer(this.phoneNumber, this.cartType, this.outletId);
}

/*
{
  "cart_id": "36c9e954-26af-4a96-9326-10207922d0b8"
}
*/
class FetchCart extends HomeEvent {
  final String cartId;

  FetchCart(this.cartId);
}

/*
{
    "cart_lines": [
        {
            "esin": "$esin",
            "quantity": {
                "quantity_number": "$qty",
                "quantity_uom": "$qtyUom"
            },
            "mrp_id": "$mrpId"
        }
    ]
}
*/
class AddToCart extends HomeEvent {
  final String esin;
  final String qty;
  final String mrpId;
  final String qtyUom;
  final String cartId;

  AddToCart(this.cartId, this.esin, this.mrpId, this.qty, this.qtyUom);
}

/*
  "code": "bdnkjdbsf"
*/
class ScanProduct extends HomeEvent {
  final String code;

  ScanProduct(this.code);
}
