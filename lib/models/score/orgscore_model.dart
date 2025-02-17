class OrgScore {
  final String message;
  final List<Score> scoreList;

  OrgScore({
    required this.message,
    required this.scoreList,
  });

  factory OrgScore.fromJson(Map<String, dynamic> json) {
    return OrgScore(
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
  final String housename;
  final double score;
  final bool isCurrentUser;

  Score({
    required this.rank,
    required this.housename,
    required this.score,
    required this.isCurrentUser,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      rank: json['Rank'],
      housename: json['Housename'],
      score: (json['Score'] as num).toDouble(),
      isCurrentUser:
          json['isCurrentUser'] ?? false, // Add null check with default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Rank': rank,
      'Housename': housename,
      'Score': score,
      'IsCurrentUser': isCurrentUser,
    };
  }
}

// class OrgScore {
//   final String message;
//   final List<Score> scoreList;

//   OrgScore({
//     required this.message,
//     required this.scoreList,
//   });

//   factory OrgScore.fromJson(Map<String, dynamic> json) {
//     return OrgScore(
//       message: json['Messages'] ?? '', // Provide a default value if null
//       scoreList: (json['Score List'] as List)
//           .map((score) => Score.fromJson(score))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'Messages': message,
//       'Score List': scoreList.map((score) => score.toJson()).toList(),
//     };
//   }
// }

// class Score {
//   final int rank;
//   final String? housename; // Make housename nullable
//   final double? score;     // Make score nullable

//   Score({
//     required this.rank,
//     this.housename, // Nullable housename
//     this.score,     // Nullable score
//   });

//   factory Score.fromJson(Map<String, dynamic> json) {
//     return Score(
//       rank: json['Rank'],
//       housename: json['Housename'] ?? '', // Default to empty string if null
//       score: json['Score'] != null ? (json['Score'] as num).toDouble() : null, // Handle null score
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'Rank': rank,
//       'Housename': housename ?? '', // Handle null housename
//       'Score': score,               // Score might be null
//     };
//   }
// }
