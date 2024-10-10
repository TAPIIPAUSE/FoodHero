class Loginresult {
  final bool success;
  final int hID;
  final String token;

  factory Loginresult.fromJson(Map<String, dynamic> json) {
    return Loginresult(success: json["success"], hID: json["hID"], token: json["token"]);
  }

  Loginresult({required this.success, required this.hID, required this.token});

  // Loginresult({required this.success, required this.hID});
}
