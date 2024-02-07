import 'package:usefulmoney/utils/constants/data_constant.dart';

class DatabaseTemplate {
  final int id;
  final String name;
  final int userId;
  final bool type;

  DatabaseTemplate(
      {required this.id,
      required this.name,
      required this.userId,
      required this.type});

  DatabaseTemplate.fromRow(Map<String, Object?> map)
      : id = map[templateIdColumn] as int,
        name = map[templateNameColumn] as String,
        userId = map[templateUserIdColumn] as int,
        type = map[templateTypeColumn] as int == 1 ? true : false;

  @override
  String toString() {
    return 'id : $id, name : $name, userId : $userId, type : $type';
  }

  @override
  bool operator ==(covariant DatabaseTemplate other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
