import 'dart:core';

import 'package:vialticecmr/model/abstract_model.dart';

class Tournee extends AbstractModel {
  @override
  final _table = 'tournee';
  final _primary = 'tournee_id';

  int _tourneeId = 0;
  String _codeTournee = '';
  String _debutTournee = '0000-00-00';
  int _nbDay = 0;
  String _hourDeb = '00:00';
  String _hourFin = '23:59';
  String _instruction = '';
  int _isMission = 0;

  Tournee(
      {required int tourneeId,
      String codeTournee = '',
      String debutTournee = '',
      int nbDay = 0,
      String hourDeb = '',
      String hourFin = '',
      String instruction = '',
      int isMission = 0}) {
    _tourneeId = tourneeId;
    _debutTournee = debutTournee;
    _codeTournee = codeTournee;
    _nbDay = nbDay;
    _hourDeb = hourDeb;
    _hourFin = hourFin;
    _instruction = instruction;
    _isMission = isMission;
  }

  int get getTourneeId => _tourneeId;
  String get getCodeTournee => _codeTournee;
  String get getDebutTournee => _debutTournee;
  int get getNbDay => _nbDay;
  String get getHourDeb => _hourDeb;
  String get getHourFin => _hourFin;
  String get getInstruction => _instruction;
  int get getIsMission => _isMission;

  Tournee.fromJson(Map<String, dynamic> json) {
    _tourneeId = int.parse(json['tournee_id']);
    _isMission = int.parse(json['is_mission']);
    _nbDay = int.parse(json['nb_day']);

    _codeTournee = json['code_tournee'];
    _debutTournee = json['debut_tournee'];
    _hourDeb = json['hour_deb'];
    _hourFin = json['hour_fin'];
    _instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['tournee_id'] = _tourneeId;
    data['hour_fin'] = _hourFin;
    data['hour_deb'] = _hourDeb;
    data['debut_tournee'] = _debutTournee;
    data['code_tournee'] = _codeTournee;
    data['nb_day'] = _nbDay;
    data['is_mission'] = _isMission;
    data['instruction'] = _instruction;
    return data;
  }

  Tournee fromBdd(Map<String, dynamic> json) {
    _tourneeId = json['tournee_id'];
    _isMission = json['is_mission'];
    _nbDay = json['nb_day'];

    _codeTournee = json['code_tournee'];
    _debutTournee = json['debut_tournee'];
    _hourDeb = json['hour_deb'];
    _hourFin = json['hour_fin'];
    _instruction = json['instruction'].toString();

    return this;
  }

  Future<Tournee> getItem() async {
    List<Map<String, dynamic>> resultat = await getOne(_tourneeId);

    if (resultat.isEmpty) {
      return Tournee(tourneeId: 0);
    }
    return fromBdd(resultat[0]);
  }

  @override
  String get primary => _primary;
  @override
  String get table => _table;
}
