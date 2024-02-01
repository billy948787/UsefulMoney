import 'package:usefulmoney/utils/constants/data_constant.dart';

class DatabaseUser {
  final int id;
  final int accountBalance;
  final String email;

  DatabaseUser(
      {required this.id, required this.accountBalance, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[userIdColumn] as int,
        accountBalance = map[userAccountBalanceColumn] as int,
        email = map[userEmailColumn] as String;

  @override
  String toString() => 'userId: $id Accountbalance : $accountBalance';

  @override
  bool operator ==(covariant DatabaseUser other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
