import 'package:mysql1/mysql1.dart';

class Database {
  final urlBase = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

  final MySqlConnection _conn;

  Database({required connection}) : _conn = connection;

  static Future<MySqlConnection> openConnection() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '123',
      db: 'academia_flutter',
    );
    final connection = await MySqlConnection.connect(settings);
    return connection;
  }

  MySqlConnection get conn => _conn;
}
