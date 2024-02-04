import 'package:usefulmoney/utils/constants/data_constant.dart';

class DatabaseTemplate {
  final int id;
  final String name;
  final int userId;

  DatabaseTemplate(
      {required this.id, required this.name, required this.userId});

  DatabaseTemplate.fromRow(Map<String, Object?> map)
      : id = map[templateIdColumn] as int,
        name = map[templateNameColumn] as String,
        userId = map[templateUserIdColumn] as int;

  @override
  String toString() {
    return 'id : $id, name : $name, userId : $userId';
  }

  @override
  bool operator ==(covariant DatabaseTemplate other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
