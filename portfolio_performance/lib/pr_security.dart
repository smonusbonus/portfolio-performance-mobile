class PRSecurity {
  String uuid;
  String name;
  String? isin;
  String? onlineId;

  PRSecurity({
    required this.uuid,
    required this.name,
    this.isin,
    this.onlineId,
  });

  factory PRSecurity.fromJson(Map<String, dynamic> json) {
    return PRSecurity(
      isin: json['isin'],
      uuid: json['uuid'],
      name: json['name'],
      onlineId: json['onlineId'],
    );
  }
}
