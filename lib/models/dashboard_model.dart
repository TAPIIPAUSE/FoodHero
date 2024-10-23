class HouseScore {
  final String message;
  final List<Score> scoreList;

  HouseScore({
    required this.message,
    required this.scoreList,
  });

  factory HouseScore.fromJson(Map<String, dynamic> json) {
    return HouseScore(
      message: json['Messages'],
      scoreList: (json['Score List'] as List)
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
  final String username;
  final double score;

  Score({
    required this.rank,
    required this.username,
    required this.score,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      rank: json['Rank'],
      username: json['Username'],
      score: (json['Score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Rank': rank,
      'Username': username,
      'Score': score,
    };
  }
}
