
import 'package:postgres/postgres.dart';
import 'package:serverapp/utils/env.dart';

class Utils {

  static  Connection? _connection;

  static Future<Connection> get dbClient  async {
    if(_connection != null &&  _connection?.isOpen == true)return _connection!;
    _connection =  await Connection.openFromUrl(Env.databaseURL);
    return _connection!;
  }
  
}

