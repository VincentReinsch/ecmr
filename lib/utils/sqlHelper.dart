import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:vialticecmr/model/destot.dart';
import 'package:vialticecmr/model/ordretransport.dart';

class SQLHelper {
  static Future<void> cleanTables() async {
    final db = await SQLHelper.db();
    await db.execute("DELETE FROM user");
    await db.execute("DELETE FROM destot");
    await db.execute("DELETE FROM  ordre_transport");
    await db.execute("DELETE FROM  parameter");
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("DROP TABLE IF EXISTS parameter");
    await database.execute("DROP TABLE IF EXISTS user");
    await database.execute("DROP TABLE IF EXISTS destot");
    await database.execute("DROP TABLE IF EXISTS ordre_transport");
    await database.execute("DROP TABLE IF EXISTS tournee");
    await database.execute("""CREATE TABLE "tournee" (
      "tournee_id" INTEGER,
      "code_tournee" TEXT,
      "debut_tournee" TEXT,
      "nb_day" INTEGER,
      "hour_deb" TEXT,
      "hour_fin" TEXT,
      "instruction" TEXT,
      "is_mission" INTEGER,
      PRIMARY KEY("tournee_id" )
    );""");
    await database.execute("""CREATE TABLE "parameter" (
      "key"	TEXT,
      "value"	TEXT,
      PRIMARY KEY("key" )
    );""");
    await database.execute("""CREATE TABLE "user" (
      "tiers_id"	INTEGER,
      "login"	TEXT UNIQUE,
      "password"	TEXT,      
      "firstname"	TEXT,
      "lastname"	TEXT,
      "url"	TEXT,
      "actual" INTEGER DEFAULT 0,
      "base_url"	TEXT,      
      PRIMARY KEY("tiers_id" AUTOINCREMENT)
    );""");
    await database.execute("""CREATE TABLE "destot" (	
          "destot_id"	INTEGER,	
          "quantite"	NUMERIC,	
          "poids"	NUMERIC,	
          "hectolitre"	REAL,	
          "metre"	REAL,	
          "is_deleted"	INTEGER DEFAULT 0,	
          "date_enlevement"	TEXT,	
          "ref_enl"	TEXT,	
          "imp_enl"	TEXT,	
          "date_livraison"	TEXT,
          "ref_liv"	TEXT,	
          "imp_liv"	TEXT,	
          "enl_arrivee"	TEXT DEFAULT '0000-00-00 00:00:00',	
          "enl_depart"	TEXT DEFAULT '0000-00-00 00:00:00',	
          "liv_arrivee"	TEXT DEFAULT '0000-00-00 00:00:00',	
          "liv_depart"	TEXT DEFAULT '0000-00-00 00:00:00',	
          "nature_marchandise"	TEXT,	
          "ordretransport_id"	INTEGER NOT NULL DEFAULT 0,	
          "enl_arrivee_latitude"	TEXT,	
          "enl_arrivee_longitude"	TEXT,	
          "enl_depart_latitude"	TEXT,	
          "enl_depart_longitude"	TEXT,
          "liv_arrivee_latitude"	TEXT,	
          "liv_arrivee_longitude"	TEXT,	
          "liv_depart_latitude"	TEXT,	
          "liv_depart_longitude"	TEXT,	
          "destot_name"	TEXT,	
          "emballage_name"	TEXT,	
          "enl_phone"	TEXT,	
          "enl_lastname"	TEXT,	
          "enl_address"	TEXT,	
          "enl_address_comp"	TEXT,	
          "enl_zipcode"	TEXT,	
          "enl_city"	TEXT,	
          "enl_country_name"	TEXT,	
          "liv_phone"	TEXT,	
          "liv_lastname"	TEXT,
          "liv_address"	TEXT,	
          "liv_address_comp"	TEXT,	
          "liv_zipcode"	TEXT,	
          "liv_city"	TEXT,	
          "liv_country_name"	TEXT, 
          "emballages"	TEXT, 
          "dest_signature" TEXT,
          "dest_signature_nom" TEXT,
          "dest_reserves" TEXT,
          "exp_signature" TEXT,
          "exp_signature_nom" TEXT,
          "exp_reserves" TEXT,
          "tracteur_immat"	TEXT,
        	"remorque_immat"	TEXT,	
          "additionnalFieldsTxt"	TEXT,
          PRIMARY KEY("destot_id"))""");
    await database.execute("""
        CREATE TABLE "ordre_transport" 
        (	"ordretransport_id"	INTEGER,
        "seg_ordretransport_id"	INTEGER,	
          "num_ot"	TEXT,	
          "tracteur_immat"	TEXT,
        	"remorque_immat"	TEXT,	
          "date_enlevement"	TEXT,	
          "date_livraison"	TEXT,	
          "instruction"	TEXT,	
          "ref_com"	TEXT,	
          "commentaire"	TEXT,
          "commentaire_conducteur"	TEXT,	
          "date_send"	TEXT,	
          "date_read"	TEXT,	
          "donneurordre_name"	TEXT,
          "donneurordre_address"	TEXT,	
          "donneurordre_address_comp"	TEXT,	
          "donneurordre_zipcode"	TEXT,
          "donneurordre_city"	TEXT,
          "donneurordre_country"	TEXT,	
          "exp_initial_name"	TEXT,	
          "exp_initial_address"	TEXT,
          "exp_initial_address_comp"	TEXT,	
          "exp_initial_zipcode"	TEXT,	
          "exp_initial_city"	TEXT,
          "exp_initial_country"	TEXT,
          "dest_final_name"	TEXT,	
          "dest_final_address"	TEXT,	
          "dest_final_address_comp"	TEXT,
          "dest_final_zipcode"	TEXT,	
          "dest_final_city"	INTEGER,	
          "dest_final_country"	INTEGER,	
          "is_deleted"	INTEGER,	
          "nb_dests"	INTEGER,	
          "status" TEXT,
          "date_upd" TEXT,
          "is_tournee" INTEGER,
          "tournee_id" INTEGER,
          "sens_enl" INTEGER,
          PRIMARY KEY("ordretransport_id"));
        """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    //await sql.deleteDatabase('demo2.db');

    var retour = await sql.openDatabase(
      'demo2.db',
      version: 8,
      onUpgrade: (sql.Database db, int oldVersion, int newVersion) async {
        await createTables(db);
      },
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );

    return retour;
  }

  // Create new item (journal)
  static Future<int> createItem(ordretransportdata) async {
    final db = await SQLHelper.db();

    OrdreTransport ordretransport = OrdreTransport.fromJson(ordretransportdata);
    final data = ordretransport.toJson();
    data['is_deleted'] = data['is_deleted'] == 'false' ? 0 : 1;

    final id = await db.insert('ordre_transport', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    if (ordretransportdata['trajets'] != null) {
      DestOt destot;
      int destotId;
      Map<String, dynamic> dataDestot;

      ordretransportdata['trajets'].forEach((song, test) async => {
            destot = DestOt.fromJson(test),
            destot.ordretransportId = ordretransport.getOrdretransportId,
            dataDestot = destot.toJson(),
            dataDestot['is_deleted'] =
                dataDestot['is_deleted'] == 'false' ? 0 : 1,
            destotId = await db.insert('destot', dataDestot,
                conflictAlgorithm: sql.ConflictAlgorithm.replace),
          });
    }

    return id;
  }

  static getParameter(parameter) async {
    final db = await SQLHelper.db();
    var retour =
        await db.query('parameter', where: '${'key = \'' + parameter}\'');

    String retourTxt = '';
    for (var element in retour) {
      retourTxt = element['value'].toString();
    }
    return retourTxt;
  }

  static setParameter(String parameter, String json) async {
    final db = await SQLHelper.db();

    await db.insert('parameter', {'key': parameter, 'value': json},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static getLastTiersId() async {
    final db = await SQLHelper.db();
    var retour = await db.query('parameter', where: 'key = \'last_tiers_id\'');

    int lastTiersId = 0;
    for (var element in retour) {
      lastTiersId = int.parse(element['value'].toString());
    }
    return lastTiersId;
  }

  static setLastTiersId(int json) async {
    final db = await SQLHelper.db();

    await db.insert('parameter', {'key': 'last_tiers_id', 'value': json},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static getLastPass() async {
    final db = await SQLHelper.db();
    var retour = await db.query('parameter', where: 'key = \'last_pass\'');

    String lastLogin = '';
    for (var element in retour) {
      lastLogin = element['value'].toString();
    }
    return lastLogin;
  }

  static setLastPass(String json) async {
    final db = await SQLHelper.db();

    await db.insert('parameter', {'key': 'last_pass', 'value': json},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static getLastLogin() async {
    final db = await SQLHelper.db();
    var retour = await db.query('parameter', where: 'key = \'last_login\'');

    String lastLogin = '';
    for (var element in retour) {
      lastLogin = element['value'].toString();
    }

    return lastLogin;
  }

  static setLastLogin(String json) async {
    final db = await SQLHelper.db();
    print("debug2");
    await db.insert('parameter', {'key': 'last_login', 'value': json},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static getLastBase() async {
    final db = await SQLHelper.db();
    var retour = await db.query('parameter', where: 'key = \'last_base\'');

    String lastBase = '';
    for (var element in retour) {
      lastBase = element['value'].toString();
    }
    return lastBase;
  }

  static setLastBase(String json) async {
    final db = await SQLHelper.db();

    await db.insert('parameter', {'key': 'last_base', 'value': json},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static gettLastDate() async {
    final db = await SQLHelper.db();
    var retour = await db.query('parameter', where: 'key = \'last_update\'');

    String dateUpd = '';
    for (var element in retour) {
      dateUpd = element['value'].toString();
    }
    return dateUpd;
  }

  static setLastDate() async {
    final db = await SQLHelper.db();

    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String lastDate = formatter.format(now);
    await db.insert('parameter', {'key': 'last_update', 'value': lastDate},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems(
      List params, Map? order) async {
    final db = await SQLHelper.db();
    order ??= {'by': 'ordretransport_id', 'sort': 'DESC'};
    Map paramsQuery = prepareParams(params);
    var sql =
        'SELECT * FROM ordre_transport LEFT JOIN tournee ON ordre_transport.tournee_id = tournee.tournee_id ';
    sql +=
        '${'${' WHERE ' + paramsQuery['where'] + ' ORDER BY ' + order['by']} ' + order['sort']} ';

    return db.rawQuery(sql, paramsQuery['args']);
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getDestOts(
      int ordretransportId) async {
    final db = await SQLHelper.db();
    var retour = db.query('destot',
        where: "ordretransport_id = ?", whereArgs: [ordretransportId]);

    return retour;
  }

  static Future<int> setDestOt(DestOt data) async {
    final db = await SQLHelper.db();

    final result = await db.update('destot', data.toJson(),
        where: "destot_id = ?", whereArgs: [data.getDestotId]);

    return result;
  }

  static Future<List<Map<String, dynamic>>> getDestOt(int destotId) async {
    final db = await SQLHelper.db();
    return db.query('destot',
        where: "destot_id = ?", whereArgs: [destotId], limit: 1);
  }

  static Map prepareParams(List params) {
    String where = ' 1 ';

    List args = [];
    for (var element in params) {
      String operator = '=';
      if (element['operator'] != null) {
        operator = element['operator'];
      }

      where += ' AND ';

      where += '${' ' + element['field']} $operator ?';
      args.add(element['value']);
    }
    return {'where': where, 'args': args};
  }

  static Future<List<Map<String, dynamic>>> getOt(int ordretransportId) async {
    final db = await SQLHelper.db();
    return db.query('ordre_transport',
        where: "ordretransport_id = ?",
        whereArgs: [ordretransportId],
        limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<int> insert(table, data) async {
    final db = await SQLHelper.db();
    final id = await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<int> update(table, int id, data, String primary) async {
    final db = await SQLHelper.db();

    final result =
        await db.update(table, data, where: "$primary = ?", whereArgs: [id]);

    return result;
  }
}
