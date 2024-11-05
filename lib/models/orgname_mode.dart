class OrgName {
  final String name;

  OrgName({required this.name});

  factory OrgName.fromJson(Map<String, dynamic> json) {
    return OrgName(
      name: json['Organiazation_Name'],
    );
  }
}
