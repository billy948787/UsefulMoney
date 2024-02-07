const dbName = 'account.db';
const userIdColumn = 'id';
const userEmailColumn = 'email';
const userAccountBalanceColumn = 'account_balance';
const bookAccountColumn = 'account';
const bookValueColumn = 'value';
const bookUserIdColumn = 'user_id';
const bookIdColumn = 'id';
const templateIdColumn = 'id';
const templateNameColumn = 'name';
const templateUserIdColumn = 'user_id';
const templateTypeColumn = 'type';
const userTable = 'user';
const bookTable = 'book';
const templateTable = 'template';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"account_balance"	INTEGER NOT NULL,
	"email"	INTEGER NOT NULL,
	PRIMARY KEY("id")
);
''';
const createBookTable = '''CREATE TABLE IF NOT EXISTS "book" (
	"account"	TEXT NOT NULL,
	"value"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"id"	INTEGER NOT NULL,
	FOREIGN KEY("user_id") REFERENCES "user"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
const createTemplateTable = '''CREATE TABLE IF NOT EXISTS "template" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"user_id"	INTEGER NOT NULL,
  "type"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';
const defaultEmail = 'default@email';
