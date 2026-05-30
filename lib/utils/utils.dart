import 'dart:developer';

import 'package:postgres/postgres.dart';
import 'package:serverapp/utils/env.dart';

class Utils {
  static Connection? client;
  
  static Future connectToDB()async{
    try {
      client = await Connection.openFromUrl(Env.databaseURL);
      log( "Connection status:: ${client?.isOpen}");
    } catch (e) {
      log(e.toString(), name: 'Database Error');
    }
  }
  
}

