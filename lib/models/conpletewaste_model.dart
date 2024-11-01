class CompleteWaste {
  int fID;

  CompleteWaste({
    required this.fID,
  });

  Map<String, dynamic> toJson() {
    return {
      'fID': fID,
    };
  }

  static completeConsume(CompleteWaste addCompleteConsume) {}
}
