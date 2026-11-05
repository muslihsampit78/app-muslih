class MenuItem {
  final int id;
  final String label;
  final String? type;
  final String? url;
  final int sortOrder;
  final List<MenuItem> children;

  MenuItem({
    required this.id,
    required this.label,
    this.type,
    this.url,
    this.sortOrder = 0,
    this.children = const [],
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    var rawChildren = json['children'];
    List<MenuItem> childrenList = [];
    if (rawChildren is List) {
      childrenList = rawChildren
          .whereType<Map<String, dynamic>>()
          .map((c) => MenuItem.fromJson(c))
          .toList();
    }

    return MenuItem(
      id: json['id'] as int? ?? 0,
      label: json['label'] as String? ?? '',
      type: json['type'] as String?,
      url: json['url'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      children: childrenList,
    );
  }
}

class Menu {
  final int id;
  final String name;
  final String location;
  final List<MenuItem> items;

  Menu({
    required this.id,
    required this.name,
    required this.location,
    this.items = const [],
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'];
    List<MenuItem> itemsList = [];
    if (rawItems is List) {
      itemsList = rawItems
          .whereType<Map<String, dynamic>>()
          .map((i) => MenuItem.fromJson(i))
          .toList();
    }

    return Menu(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      items: itemsList,
    );
  }
}

