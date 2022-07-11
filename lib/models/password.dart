import 'package:hive_flutter/hive_flutter.dart';

part 'hive_adapters/password.g.dart';

@HiveType(typeId: 1)
class Password {
  @HiveField(0)
  String websiteName; //(website,app,service) Name

  @HiveField(1)
  String icon;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String lastUpdated;

  // @HiveField(5)
  // String url;



  @HiveField(5)
  String category;

  @HiveField(6)
  String id;

  Password({
    required this.websiteName,
    required this.icon,
    required this.email,
    required this.password,
    required this.lastUpdated,
    required this.category,
    required this.id,
  });
}
