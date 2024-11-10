class ConfirmConsumeDetail {
  int cID;
  int Percent;

  ConfirmConsumeDetail({
    required this.cID,
    required this.Percent
  });

  Map<String, dynamic> toJson() {
    return {
      'cID': cID,
      'Percent':Percent
    };
  }

  static completeConsume(ConfirmConsumeDetail addCompleteConsumeDetail) {}
}
