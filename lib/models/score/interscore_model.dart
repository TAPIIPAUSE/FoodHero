class InterScore {
  final String message;
  final List<Score> scoreList;

  InterScore({
    required this.message,
    required this.scoreList,
  });

  factory InterScore.fromJson(Map<String, dynamic> json) {
    return InterScore(
      message: json['Messages'],
      scoreList: (json['Score_List'] as List)
          .map((score) => Score.fromJson(score))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Messages': message,
      'Score List': scoreList.map((score) => score.toJson()).toList(),
    };
  }
}

class Score {
  final int rank;
  final String orgname;
  final double score;
  final bool isCurrentUser;

  Score({
    required this.rank,
    required this.orgname,
    required this.score,
    required this.isCurrentUser,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      rank: json['Rank'],
      orgname: json['Orgname'],
      score: (json['Score'] as num).toDouble(),
      isCurrentUser:
          json['isCurrentUser'] ?? false, // Add null check with default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Rank': rank,
      'Orgname': orgname,
      'Score': score,
    };
  }
}
