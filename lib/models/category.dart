import 'package:hive_flutter/hive_flutter.dart';

part 'hive_adapters/category.g.dart';

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  String name;

  @HiveField(1)
  String icon;

  Category({
    required this.name,
    required this.icon,
  });
}
