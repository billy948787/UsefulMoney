import 'package:usefulmoney/utils/constants/data_constant.dart';

class DatabaseBook {
  final int id;
  final int userId;
  final int value;
  final String accountName;

  DatabaseBook(
      {required this.id,
      required this.userId,
      required this.value,
      required this.accountName});

  DatabaseBook.fromRow(Map<String, Object?> map)
      : id = map[bookIdColumn] as int,
        userId = map[bookUserIdColumn] as int,
        value = map[bookValueColumn] as int,
        accountName = map[bookAccountColumn] as String;

  @override
  bool operator ==(covariant DatabaseBook other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
