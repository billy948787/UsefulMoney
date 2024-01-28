import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:usefulmoney/services/crud/exceptions.dart';
import 'package:path_provider/path_provider.dart';

class AccountService {
  static final _shared = AccountService._internal();
  AccountService._internal() {
    _controller = StreamController<List<DatabaseBook>>.broadcast(
      onListen: () {
        _controller.sink.add(_data);
      },
    );
  }
  factory AccountService() => _shared;

  Database? _db;
  DatabaseUser? _user;
  List<DatabaseBook> _data = [];
  late final StreamController<List<DatabaseBook>> _controller;

  Stream<List<DatabaseBook>> get allAccounts => _controller.stream;

  Future<DatabaseUser> getUserOrCreateUser(
      {required String email, bool setAsCurrent = true}) async {
    try {
      final user = await getUser(email: email);
      if (setAsCurrent) {
        _user = user;
      }
      return user;
    } on UserNotExistException {
      final user = await createUser(email: email);
      if (setAsCurrent) {
        _user = user;
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheAccount() async {
    await _ensureDatabaseIsOpen();
    final user = _user;
    if (user != null) {
      final accounts = await getAllAccount();
      _data = accounts;
      _controller.add(_data);
    } else {
      throw ShouldCreateUserFirstException();
    }
  }

  Future<List<DatabaseBook>> getAllAccount() async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final list = await db.query(
      bookTable,
    );

    final result = list.map((rows) => DatabaseBook.fromRow(rows)).toList();

    return result;
  }

  Future<DatabaseBook> getAccount({required int id}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      bookTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    return DatabaseBook.fromRow(result.first);
  }

  Future<DatabaseBook> updateAccount({
    required int id,
    required String accountName,
    required int value,
  }) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.update(
      bookTable,
      {
        bookAccountColumn: accountName,
        bookValueColumn: value,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result != 1) {
      throw CouldNotUpdateAccount();
    }

    final account = await getAccount(id: id);

    _data.add(account);
    _controller.add(_data);

    return account;
  }

  Future<void> deleteAllAccount({required int userId}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.delete(
      bookTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (result == 0) {
      throw CouldNotDeleteAccount();
    }

    _data.clear();
    _controller.add(_data);
  }

  Future<void> deleteAccount({required int id}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.delete(
      bookTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result != 1) {
      throw CouldNotDeleteAccount();
    }

    _data.removeWhere((element) => element.id == id);
    _controller.add(_data);
  }

  Future<DatabaseBook> createAccount({
    required String name,
    required int value,
    required DatabaseUser owner,
  }) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final email = owner.email;
    final user = await getUser(email: email);

    if (user != owner) {
      throw CouldNotFindUser();
    }

    final accountId = await db.insert(bookTable, {
      bookValueColumn: value,
      bookAccountColumn: name,
      bookUserIdColumn: owner.id,
    });

    final account = DatabaseBook(
      id: accountId,
      userId: owner.id,
      value: value,
      accountName: name,
    );

    _data.add(account);
    _controller.add(_data);

    return account;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) {
      throw UserNotExistException();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final deleteCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (deleteCount != 1) {
      throw UserNotExistException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final userId = await db.insert(userTable, {
      userEmailColumn: email,
      userAccountBalanceColumn: 0,
    });
    return DatabaseUser(
      id: userId,
      accountBalance: 0,
      email: email.toLowerCase(),
    );
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> _ensureDatabaseIsOpen() async {
    if (_db == null) {
      await open();
    } else {
      return;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseAlreadyClosedException();
    }
    await db.close();
    _db = null;
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docPath = await getApplicationCacheDirectory();
      final dbPath = join(docPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      //create user table
      await db.execute(userTable);
      //create book table
      await db.execute(bookTable);

      await _cacheAccount();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }
}

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

const dbName = 'account.db';
const userIdColumn = 'id';
const userEmailColumn = 'email';
const userAccountBalanceColumn = 'account_balance';
const bookAccountColumn = 'account';
const bookValueColumn = 'value';
const bookUserIdColumn = 'user_id';
const bookIdColumn = 'id';
const userTable = '''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"account_balance"	INTEGER NOT NULL,
	"email"	INTEGER NOT NULL,
	PRIMARY KEY("id")
);''';
const bookTable = '''CREATE TABLE IF NOT EXISTS "book" (
	"account"	TEXT NOT NULL,
	"value"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

const defaultUserEmail = 'default@email.com';
