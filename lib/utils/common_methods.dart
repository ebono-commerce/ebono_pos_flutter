bool isValidOfferId(String offerId) {
  return offerId.length == 8 ||
      offerId.length == 10 ||
      offerId.length == 12 ||
      offerId.length == 13;
}
