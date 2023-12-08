import 'package:flutter/material.dart';
import 'package:vialticecmr/model/user.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';

class MyVariables {
  static final MyVariables _instance = MyVariables._internal();
  // passes the instantiation to the _instance object
  factory MyVariables() => _instance;

  //initialize variables in here
  MyVariables._internal() {
    _myObject = User(
      login: '',
      password: '',
      url: 'appli.vialtic.com',
      baseUrl: '',
      baseName: '',
      tiersId: 0,
      firstname: '',
      lastName: '',
    );
    _myTheme = ThemeData(
      primarySwatch: Colors.blue,
    );
    _token = '';
    _tempPath = '';
    _infoversion = '';
    _currentContext = null;
    _connected = true;
  }
  bool _connected = true;
  String _token = '';
  String _infoversion = '';
  String _tempPath = '';
  String _dateFilter = '';
  dynamic _currentContext;
  User _myObject = User(
    login: 'd',
    password: '',
    url: 'appli.vialtic.com',
    baseUrl: '',
    baseName: '',
    tiersId: 0,
    firstname: '',
    lastName: '',
  );

  final Map<String, TextStyle> _styles = {
    'style_h1': const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.deepOrange,
    ),
    'style_p': const TextStyle(
      fontSize: 11,
    )
  };
  List<Widget> _piedpage = [
    const Text('Connectez-vous'),
  ];

  ThemeData _myTheme = ThemeData(
    primaryColor: Colors.red,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
        .copyWith(background: Colors.green),
  );

  //Future<List> test ;

  //short getter for my variable
  bool get getConnected => _connected;
  String get token => _token;
  String get infoversion => _infoversion;
  User get getMyObject => _myObject;
  String get getMyPath => _tempPath;
  String get getDateFilter => _dateFilter;
  dynamic get getMyCurrentContext => _currentContext;

  ThemeData get myTheme => _myTheme;
  List<Widget> get piedpage => _piedpage;
  Map<String, TextStyle> get styles => _styles;

  //short setter for my variable

  set piedpage(List<Widget> value) => _piedpage = value;
  set myObject(User value) => _myObject = value;
  void setConnected(bool value) => _connected = value;
  void setToken(String value) => _token = value;
  void dateFilter(String value) => _dateFilter = value;
  void basePath(String value) => _tempPath = value;
  void baseUrl(String value) => getMyObject.baseUrl = value;
  void baseName(String value) => getMyObject.baseName = value;
  void setLogin(String value) => getMyObject.login = value;
  void setPass(String value) => getMyObject.password = value;
  void setTiersId(int value) => getMyObject.tiersId = value;
  void setInfoVersion(String value) => _infoversion = value;
  void setCurrentContext(dynamic value) => _currentContext = value;
  set myTheme(ThemeData value) => {_myTheme = value};
  void disconnect() {
    getMyObject.password = '';
  }

  void afterConnect(responseLogin) {
    getMyObject.login = responseLogin['login'];
    getMyObject.password = responseLogin['password'];
    getMyObject.baseUrl = responseLogin['base_url'];
    getMyObject.tiersId = int.parse(responseLogin['tiers_id']);
  }

  void setUser(datas) {
    getMyObject.firstName = datas['getFirstName'];
    getMyObject.lastName = datas['getLastName'];
  }

  void setConnect(responseLogin) {
    if (responseLogin.runtimeType == Object) {
      getMyObject.firstName = responseLogin.firstname;
      getMyObject.lastName = responseLogin['lastname'];
      getMyObject.tiersId = responseLogin['tiers_id'];
    } else {
      getMyObject.firstName = responseLogin.getFirstName;
      getMyObject.lastName = responseLogin.getLastName;
      getMyObject.tiersId = responseLogin.getTiersId;
    }
    SQLHelper.setParameter('firstname', getMyObject.getFirstName);
    SQLHelper.setParameter('lastname', getMyObject.getLastName);
    SQLHelper.setLastTiersId(responseLogin.getTiersId);
  }
}
