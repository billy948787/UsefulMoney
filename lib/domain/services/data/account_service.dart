import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';
import 'package:usefulmoney/utils/constants/data_constant.dart';
import 'package:usefulmoney/domain/services/data/exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:usefulmoney/domain/services/data/type/database_book.dart';
import 'package:usefulmoney/domain/services/data/type/database_user.dart';

class AccountService {
  static final _shared = AccountService._internal();
  AccountService._internal() {
    _accountController = StreamController<List<DatabaseBook>>.broadcast(
      onListen: () {
        _accountController.sink.add(_data);
      },
    );
    _balanceController = StreamController<int>.broadcast(
      onListen: () {
        _balanceController.sink.add(_balance);
      },
    );
    _templateController = StreamController.broadcast(
      onListen: () {
        _templateController.sink.add(_templates);
      },
    );
  }
  factory AccountService() => _shared;

  DatabaseUser? _user;
  Database? _db;
  List<DatabaseBook> _data = [];
  int _balance = 0;
  List<DatabaseTemplate> _templates = [];
  late final StreamController<List<DatabaseTemplate>> _templateController;
  late final StreamController<List<DatabaseBook>> _accountController;
  late final StreamController<int> _balanceController;

  Stream<List<DatabaseBook>> get allAccounts => _accountController.stream;
  Stream<int> get balance => _balanceController.stream;
  Stream<List<DatabaseTemplate>> get allTemplates => _templateController.stream;

  DatabaseUser getCurrentUserOrThrow() {
    if (_user != null) {
      return _user!;
    } else {
      throw UserNotExistException();
    }
  }

  Future<DatabaseUser> getUserOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      _user = user;
      return user;
    } on UserNotExistException {
      final user = await createUser(email: email);
      _user = user;
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cache() async {
    await _ensureDatabaseIsOpen();

    final accounts = await getAllAccount();
    final user = await getUserOrCreateUser(email: defaultEmail);

    _balance = user.accountBalance;
    _balanceController.add(_balance);
    _templates = await getAllTemplate(userId: user.id);
    _templateController.add(_templates);
    _data = accounts;
    _accountController.add(_data);
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

    final query = await db.query(bookTable, where: 'id = ?', whereArgs: [id]);
    final previousAccount = DatabaseBook.fromRow(query.first);
    final preViousvalue = previousAccount.value;
    await updateUserBalance(
      userId: previousAccount.userId,
      value: value - preViousvalue,
    );

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

    _data.removeWhere((element) => element.id == id);
    _data.add(account);
    _accountController.add(_data);

    return account;
  }

  Future<void> deleteAllAccount({required int userId}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final query = await db.query(
      bookTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    final accountList = query.map((map) => DatabaseBook.fromRow(map));
    const initialValue = 0;
    final value = accountList.fold(initialValue,
        (previousValue, account) => previousValue + account.value);

    await updateUserBalance(
      userId: userId,
      value: -value,
    );

    final result = await db.delete(
      bookTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (result == 0) {
      throw CouldNotDeleteAccount();
    }

    _data.clear();
    _accountController.add(_data);
  }

  Future<void> deleteAccount({required int id}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();
    //find the account that user want to delete, then get the value in order to change the balance.
    final query = await db.query(bookTable, where: 'id = ?', whereArgs: [id]);
    final account = DatabaseBook.fromRow(query.first);
    final value = account.value;
    await updateUserBalance(
      userId: account.userId,
      value: -value,
    );

    final result = await db.delete(
      bookTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result != 1) {
      throw CouldNotDeleteAccount();
    }
    _data.removeWhere((element) => element.id == id);
    _accountController.add(_data);
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

    await updateUserBalance(
      userId: owner.id,
      value: value,
    );

    final account = DatabaseBook(
      id: accountId,
      userId: owner.id,
      value: value,
      accountName: name,
    );

    _data.add(account);
    _accountController.add(_data);

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

  Future<void> updateUserBalance({
    required int userId,
    required int value,
  }) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final balanceColumn = await (db.query(
      userTable,
      where: 'id = ?',
      whereArgs: [userId],
      columns: [userAccountBalanceColumn],
    ));
    final previousBalance =
        balanceColumn.first[userAccountBalanceColumn] as int;

    final result = await db.update(
      userTable,
      {userAccountBalanceColumn: previousBalance + value},
    );

    if (result != 1) {
      throw CouldNotUpdateBalance();
    }

    _balance += value;
    _balanceController.add(_balance);
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

  Future<DatabaseTemplate> updateTemplate(
      {required String name, required int id}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.update(
      templateTable,
      {
        templateNameColumn: name,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result != 1) {
      throw CouldNotUpdateTemplate();
    }

    final template = await getTemplate(id: id);
    _templates.removeWhere((element) => element.id == id);
    _templates.add(template);
    _templateController.add(_templates);

    return template;
  }

  Future<void> deleteAllTemplate({required int userId}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.delete(
      templateTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (result < 1) {
      throw CouldNotDeleteAccount();
    }

    _templates = [];
    _templateController.add(_templates);
  }

  Future<void> deleteTemplate({required int id}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.delete(
      templateTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result != 1) {
      throw CouldNotDeleteTemplate();
    }

    _templates.removeWhere((element) => element.id == id);
    _templateController.add(_templates);
  }

  Future<List<DatabaseTemplate>> getAllTemplate({required int userId}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final list = await db.query(
      templateTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return list.map((map) => DatabaseTemplate.fromRow(map)).toList();
  }

  Future<DatabaseTemplate> getTemplate({required int id}) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      templateTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    return DatabaseTemplate.fromRow(result.first);
  }

  Future<DatabaseTemplate> createTemplate({
    required String name,
    required int userId,
    required bool type,
  }) async {
    await _ensureDatabaseIsOpen();
    final db = _getDatabaseOrThrow();

    final trySearch = await db.query(
      templateTable,
      where: 'name = ?',
      whereArgs: [name],
    );

    if (trySearch.isNotEmpty) {
      throw CanNotCreateSameTemplate();
    }

    final id = await db.insert(templateTable, {
      templateNameColumn: name,
      templateUserIdColumn: userId,
      templateTypeColumn: type ? 1 : 0,
    });

    final template = DatabaseTemplate(
      id: id,
      name: name,
      userId: userId,
      type: type,
    );

    _templates.add(template);
    _templateController.add(_templates);

    return template;
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
      await db.execute(createUserTable);
      //create book table
      await db.execute(createBookTable);
      //create template table
      await db.execute(createTemplateTable);

      await _cache();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }

  Future<void> deleteDatabase() async {
    final docPath = await getApplicationCacheDirectory();
    final dbPath = join(docPath.path, dbName);
    return databaseFactory.deleteDatabase(dbPath);
  }

  Future<void> resetDatabase({required String email}) async {
    await close();
    await deleteDatabase();
    await open();
  }
}
