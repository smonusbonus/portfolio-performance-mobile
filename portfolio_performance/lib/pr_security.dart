class PRSecurity {
  String? uuid;
  String? isin;
  String? name;
  String? onlineId;

  PRSecurity({
    this.uuid,
    this.isin,
    this.name,
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
