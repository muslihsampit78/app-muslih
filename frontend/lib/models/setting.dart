class AppSetting {
  final String group;
  final String key;
  final String name;
  final dynamic value;
  final String type;

  AppSetting({
    required this.group,
    required this.key,
    required this.name,
    this.value,
    required this.type,
  });

  factory AppSetting.fromJson(Map<String, dynamic> json) {
    return AppSetting(
      group: json['group'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      value: json['value'],
      type: json['type'] as String? ?? 'text',
    );
  }
}

