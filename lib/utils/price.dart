String getActualPrice(int? centAmount, int? fraction) {
  if (centAmount == null) {
    return '₹0.00';
  }

  double amount = (centAmount / fraction!);

  return '₹${amount.toStringAsFixed(2)}';
}

double getPrice(int? centAmount, int? fraction) {
  if (centAmount == null) {
    return 0.00;
  }

  double amount = (centAmount / fraction!);

  return amount;
}

String getActualPriceWithoutSymbol(int? centAmount, int? fraction) {
  if (centAmount == null) {
    return '';
  }

  double amount = (centAmount / fraction!);

  return amount.toStringAsFixed(2);
}

String getTenderAmountString(String value){
  if(value.isEmpty){
    return "";
  }

 return  (double.tryParse(value) ?? 0.00).toStringAsFixed(2);
}