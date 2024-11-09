class HHOrgInfo {
  final int hId;
  final int orgId;

  factory HHOrgInfo.fromJson(Map<String, dynamic> json) {
    return HHOrgInfo(
      hId: json['hID'],
      orgId: json['orgID'],
    );
  }

  HHOrgInfo({required this.hId, required this.orgId});
}
