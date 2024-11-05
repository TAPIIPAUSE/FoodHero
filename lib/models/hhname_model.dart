class HHName {
  final String name;

  HHName({required this.name});

  factory HHName.fromJson(Map<String, dynamic> json) {
    return HHName(
      name: json['House_Name'],
    );
  }
}
