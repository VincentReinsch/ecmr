import '../utils/sqlHelper.dart';

class AbstractModel {
  final db = SQLHelper.db();

  final String _table = '';
  final String _primary = '';

  String get primary => _primary;
  String get table => _table;

  Future<int> add(datas) async {
    Map dat = datas.toJson();

    final id = await SQLHelper.insert(table, dat);

    return id;
  }

  Future<int> update(datas) async {
    var primaryField = datas[primary];
    datas.remove(primary);

    try {
      final id = await SQLHelper.update(table, primaryField, datas, primary);
      return id;
    } catch (e) {}
    return 0;
  }

  Future<List<Map<String, dynamic>>> getOne(int id) async {
    final db = await SQLHelper.db();
    var retour =
        db.query(table, where: "$primary = ?", whereArgs: [id], limit: 1);

    return retour;
  }
}
