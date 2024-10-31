class CompleteConsume {

  int fID;
  

  CompleteConsume(
      {required this.fID,
    });

  Map<String, dynamic> toJson() {
    return {
      'fID': fID,
     
    };
  }

  static completeConsume(CompleteConsume addCompleteConsume) {}
}
