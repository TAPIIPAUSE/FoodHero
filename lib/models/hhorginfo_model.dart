class HHOrgInfo {
  final int hId;
  final int orgId;
  final bool isFamilyLead;
  final bool isOrgLeader;

  factory HHOrgInfo.fromJson(Map<String, dynamic> json) {
    return HHOrgInfo(
      hId: json['hID'],
      orgId: json['orgID'],
      isFamilyLead: json['isFamilyLead'],
      isOrgLeader: json['isOrgLead'],
    );
  }

  HHOrgInfo({
    required this.hId,
    required this.orgId,
    required this.isFamilyLead,
    required this.isOrgLeader,
  });
}
