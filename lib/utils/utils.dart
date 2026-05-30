
import 'package:postgres/postgres.dart';
import 'package:serverapp/utils/env.dart';

class Utils {

  static Future<Connection> get dbClient  async => await Connection.openFromUrl(Env.databaseURL);
  
}

