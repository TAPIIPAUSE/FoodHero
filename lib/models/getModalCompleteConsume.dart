class GetModalCompleteConsume {
  final int scoreGained;
  final int save;


  GetModalCompleteConsume(
      {
      required this.scoreGained,
      required this.save


      });


  Map<String, dynamic> toJson() {
    return {
      'scoreGained': scoreGained,
      'save': save,
    };
  }


  factory GetModalCompleteConsume.fromJson(Map<String, dynamic> json) {
    return GetModalCompleteConsume(
      scoreGained: json['scoreGained'] ?? 0,
      save: json['save'] ?? 0,

  
    );
  }


  GetModalCompleteConsume copyWith({
    int? scoreGained,
    int? save,
  
  }) {
    return GetModalCompleteConsume(
      scoreGained: scoreGained ?? this.scoreGained,
      save: save ?? this.save,
     
    );
  }

  @override
  String toString() {
    return 'getFoodModal(scoreGained: $scoreGained, save: $save, )';
  
  }
}
