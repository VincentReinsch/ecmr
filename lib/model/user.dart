import 'package:vialticecmr/model/abstract_model.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';

class User extends AbstractModel {
  @override
  final _table = 'user';
  final _primary = 'tiers_id';

  String _login = '';
  String _password = '';
  int _tiersId = 0;
  String _firstname = '';
  String _lastName = '';
  String _url = '';
  String _baseUrl = '';
  String _baseName = '';
  int _actual = 0;

  // constructor

  User({
    String login = '',
    String password = '',
    int tiersId = 0,
    String firstname = '',
    String lastName = '',
    String url = '',
    String baseUrl = '',
    String baseName = '',
  }) {
    _login = login;
    _password = password;
    _tiersId = tiersId;
    _firstname = firstname;
    _lastName = lastName;
    _url = url;
    _baseUrl = baseUrl;
    _baseName = baseName;
  }
  // Properties

  int get getTiersId => _tiersId;
  int get getActual => _actual;
  String get getLogin => _login;
  String get getPassword => _password;
  String get getFirstName => _firstname;
  String get getLastName => _lastName;
  String get getBaseUrl => _baseUrl;
  String get getBaseName => _baseName;
  String get getUrl => _url;

  set password(String password) => _password = password;
  set login(String login) => _login = login;
  set tiersId(int tiersId) => _tiersId = tiersId;
  set firstName(String firstname) => _firstname = firstname;
  set lastName(String lastName) => _lastName = lastName;
  set baseUrl(String baseUrl) => _baseUrl = baseUrl;
  set baseName(String baseName) => _baseName = baseName;
  set url(String url) => _url = url;

  // create the user object from json input
  User.fromJson(Map<String, dynamic> json) {
    _tiersId = int.parse(json['params']['tiers_id']);
    _firstname = json['params']['firstname'];
    _lastName = json['params']['lastname'];
    _baseUrl = json['params']['base_url'];
    //_baseName = json['params']['base_name'];
    _login = json['params']['login'];
    _password = json['params']['password'];
    _actual = json['params']['actual'];
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tiers_id'] = _tiersId;
    data['firstname'] = _firstname;
    data['lastname'] = _lastName;
    data['url'] = _url;
    data['base_url'] = _baseUrl;
    data['base_name'] = _baseName;
    data['login'] = _login;
    data['password'] = _password;
    data['actual'] = _actual;

    return data;
  }

  get_actual() {}

  @override
  String get primary => _primary;
  @override
  String get table => _table;


  Future<int> erase_actual() async {
    final db = await SQLHelper.db();
    Map<String, Object?> data = {};
    data['actual'] = 0;
    final result = await db.update(table, data, where: "1");

    return result;
  }
}
