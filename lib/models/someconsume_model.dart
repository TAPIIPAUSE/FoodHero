class SomeConsume {
  int fID;
  int retrievedQuantity;
  int retrievedAmount;

  SomeConsume({
    required this.fID,
    required this.retrievedQuantity,
    required this.retrievedAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'fID': fID,
      'retrievedQuantity': retrievedQuantity,
      'retrievedAmount': retrievedAmount
    };
  }

  static completeConsume(SomeConsume addCompleteConsume) {}
}
