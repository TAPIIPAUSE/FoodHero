class HouseholdFoodSaved {
  final String messages;
  final int documentNumber;
  final List<WeekData> weekList;

  HouseholdFoodSaved({
    required this.messages,
    required this.documentNumber,
    required this.weekList,
  });

  factory HouseholdFoodSaved.fromJson(Map<String, dynamic> json) {
    return HouseholdFoodSaved(
      messages: json['Messages'] as String,
      documentNumber: json['Document_Number'] as int,
      weekList: (json['Week_List'] as List)
          .map((week) => WeekData.fromJson(week))
          .toList(),
    );
  }
}

class WeekData {
  final String date;
  final int consume;
  final int total;
  final double percent;

  WeekData({
    required this.date,
    required this.consume,
    required this.total,
    required this.percent,
  });

  Map<String, dynamic> toMap() {
    return {
      'Date': date,
      'Consume': consume,
      'Total': total,
      'Percent': percent,
    };
  }

  factory WeekData.fromJson(Map<String, dynamic> json) {
    return WeekData(
      date: json['Date'] as String,
      consume: json['Consume'] as int,
      total: json['Total'] as int,
      percent: (json['Percent'] as num).toDouble(),
    );
  }
}

