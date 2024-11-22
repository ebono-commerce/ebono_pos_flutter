String getActualPrice(int? centAmount, int? fraction) {
  if (centAmount == null) {
    return '₹0.00';
  }

  double amount = (centAmount / fraction!);

  return '₹${amount.toStringAsFixed(2)}';
}