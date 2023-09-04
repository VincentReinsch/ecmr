class AdminUser {
  final String login = 'vreinsch2';
  final String password = '97fc3876d42015cf497ab2c5dd3a47d831c9576c';
  final String url = 'appli.vialtic.com';
  final String baseUrl = '';
  final String tiersId = '';
  final String firstname = '';
  final String lastname = '';

  AdminUser({tiersId, login});

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      tiersId: json['tiersId'],
      login: json['login'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['password'] = password;
    data['url'] = url;
    data['baseUrl'] = baseUrl;
    data['tiersId'] = tiersId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;

    return data;
  }
}
