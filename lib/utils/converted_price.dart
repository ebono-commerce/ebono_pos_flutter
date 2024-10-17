String convertedPrice(int centAmount, int fraction) {
  double amount = (centAmount / fraction);

  return '₹${amount.toStringAsFixed(2)}';
}
