class CompleteConsumeDetail {
  int cID;
  int Percent;

  CompleteConsumeDetail({
    required this.cID,
    required this.Percent
  });

  Map<String, dynamic> toJson() {
    return {
      'cID': cID,
      'Percent':Percent
    };
  }

  static completeConsume(CompleteConsumeDetail addCompleteConsumeDetail) {}
}
