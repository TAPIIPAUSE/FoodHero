class OrgFoodSaved {
  final String messages;
  final int documentNumber;
  final List<WeekData> weekList;

  OrgFoodSaved({
    required this.messages,
    required this.documentNumber,
    required this.weekList,
  });

  factory OrgFoodSaved.fromJson(Map<String, dynamic> json) {
    return OrgFoodSaved(
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
  final int waste;
  final int total;
  final double consumePercent;
  final double wastePercent;

  WeekData({
    required this.date,
    required this.consume,
    required this.waste,
    required this.total,
    required this.consumePercent,
    required this.wastePercent,
  });

  Map<String, dynamic> toMap() {
    return {
      'Date': date,
      'Consume': consume,
      'Total': total,
      'ConsumePercent': consumePercent,
      'WastePercent': wastePercent,
    };
  }

  factory WeekData.fromJson(Map<String, dynamic> json) {
    return WeekData(
      date: json['Date'] as String,
      consume: json['Consume'] ?? 0,
      waste: json['Wasted'] ?? 0,
      total: json['Total'] ?? 0,
      consumePercent: (json['consumePercent'] as num?)?.toDouble() ?? 0.0,  // Default to 0.0 if null
      wastePercent: (json['wastePercent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
