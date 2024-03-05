import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:vialticecmr/model/abstract_model.dart';
import 'package:vialticecmr/model/destot.dart';
import 'package:vialticecmr/model/tournee.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/network.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';

class OrdreTransport extends AbstractModel {
  @override
  final _table = 'ordre_transport';
  final _primary = 'ordretransport_id';

  int _ordretransportId = 0;
  int _segOrdretransportId = 0;
  String _numOt = '';
  final List _status = [];
  String _tracteurImmat = '';
  String _remorqueImmat = '';
  String _dateEnlevement = '0000-00-00 00:00:00';
  String _dateLivraison = '0000-00-00 00:00:00';
  String _instruction = '';
  String _refCom = '';
  String _refEnl = '';
  String _impEnl = '';
  String _refLiv = '';
  String _impLiv = '';
  String _instructions = '';

  String _commentaire = '';
  String _commentaireConducteur = '';
  String _dateSend = '0000-00-00 00:00:00';
  String _dateRead = '0000-00-00 00:00:00';

  String _donneurordreName = '';
  String _donneurordreAddress = '';
  String _donneurordreAddressComp = '';
  String _donneurordreZipcode = '';
  String _donneurordreCity = '';
  String _donneurordreCountry = '';
  String _expInitialName = '';
  String _expInitialAddress = '';
  String _expInitialAddressComp = '';
  String _expInitialZipcode = '';
  String _expInitialCity = '';
  String _expInitialCountry = '';
  String _destFinalName = '';
  String _destFinalAddress = '';
  String _destFinalAddressComp = '';
  String _destFinalZipcode = '';
  String _destFinalCity = '';
  String _destFinalCountry = '';
  int _tourneeId = 0;
  int _sensEnl = 0;
  bool _isDeleted = false;
  bool _isClonable = false;
  int _nbDests = 0;
  List<DestOt> _destots = [];

  OrdreTransport({
    required int ordretransportId,
    int segOrdretransportId = 0,
    String numOt = '',
    String tracteurImmat = '',
    String remorqueImmat = '',
    String dateEnlevement = '0000-00-00 00:00:00',
    String dateLivraison = '0000-00-00 00:00:00',
    String instruction = '',
    String refCom = '',
    String commentaire = '',
    String commentaireConducteur = '',
    String dateSend = '0000-00-00 00:00:00',
    String dateRead = '0000-00-00 00:00:00',
    String donneurordreName = '',
    String donneurordreAddress = '',
    String donneurordreAddressComp = '',
    String donneurordreZipcode = '',
    String donneurordreCity = '',
    String donneurordreCountry = '',
    String expInitialName = '',
    String expInitialAddress = '',
    String expInitialAddressComp = '',
    String expInitialZipcode = '',
    String expInitialCity = '',
    String expInitialCountry = '',
    String destFinalName = '',
    String destFinalAddress = '',
    String destFinalAddressComp = '',
    String destFinalZipcode = '',
    String destFinalCity = '',
    String destFinalCountry = '',
    bool isDeleted = false,
    bool isClonable = false,
    int nbDests = 0,
    int tourneeId = 0,
    int sensEnl = 0,

    //List<DestOt> destots = [],
  }) {
    _ordretransportId = ordretransportId;
    _segOrdretransportId = segOrdretransportId;
    _numOt = numOt;

    _tracteurImmat = tracteurImmat;
    _remorqueImmat = remorqueImmat;
    _dateEnlevement = dateEnlevement;
    _dateLivraison = dateLivraison;
    _instruction = instruction;
    _refCom = refCom;
    _commentaire = commentaire;
    _commentaireConducteur = commentaireConducteur;
    _dateSend = dateSend;
    _dateRead = dateRead;

    _donneurordreName = donneurordreName;
    _donneurordreAddress = donneurordreAddress;
    _donneurordreAddressComp = donneurordreAddressComp;
    _donneurordreZipcode = donneurordreZipcode;
    _donneurordreCity = donneurordreCity;
    _donneurordreCountry = donneurordreCountry;
    _expInitialName = expInitialName;
    _expInitialAddress = expInitialAddress;
    _expInitialAddressComp = expInitialAddressComp;
    _expInitialZipcode = expInitialZipcode;
    _expInitialCity = expInitialCity;
    _expInitialCountry = expInitialCountry;
    _destFinalName = destFinalName;
    _destFinalAddress = destFinalAddress;
    _destFinalAddressComp = destFinalAddressComp;
    _destFinalZipcode = destFinalZipcode;
    _destFinalCity = destFinalCity;
    _destFinalCountry = destFinalCountry;
    _isDeleted = isDeleted;
    _isClonable = isClonable;
    _nbDests = nbDests;
    _destots = destots;
    _tourneeId = tourneeId;
    _sensEnl = sensEnl;
  }

  int get getOrdretransportId => _ordretransportId;
  int get getSegOrdretransportId => _segOrdretransportId;
  String get getNumOt => _numOt;

  String get getTracteurImmat => _tracteurImmat;
  String get getRemorqueImmat => _remorqueImmat;
  String get getDateEnlevement => _dateEnlevement;
  String get getDateLivraison => _dateLivraison;
  String get getInstruction => _instruction;
  String get getRefCom => _refCom;
  String get getCommentaire => _commentaire;
  String get getCommentaireConducteur => _commentaireConducteur;
  String get getDateSend => _dateSend;
  String get getDateRead => _dateRead;

  String get getDonneurordreName => _donneurordreName;
  String get getDonneurordreAddress => _donneurordreAddress;
  String get getDonneurordreAddressComp => _donneurordreAddressComp;
  String get getDonneurordreZipcode => _donneurordreZipcode;
  String get getDonneurordreCity => _donneurordreCity;
  String get getDonneurordreCountry => _donneurordreCountry;
  String get getExpInitialName => _expInitialName;
  String get getExpInitialAddress => _expInitialAddress;
  String get getExpInitialAddressComp => _expInitialAddressComp;
  String get getExpInitialZipcode => _expInitialZipcode;
  String get getExpInitialCity => _expInitialCity;
  String get getExpInitialCountry => _expInitialCountry;
  String get getDestFinalName => _destFinalName;
  String get getDestFinalAddress => _destFinalAddress;
  String get getDestFinalAddressComp => _destFinalAddressComp;
  String get getDestFinalZipcode => _destFinalZipcode;
  String get getDestFinalCity => _destFinalCity;
  int get getTourneeId => _tourneeId;
  int get getSensEnl => _sensEnl;
  String get getDestFinalCountry => _destFinalCountry;
  bool get getIsDeleted => _isDeleted;
  bool get getIsClonable => _isClonable;
  int get getNbDests => _nbDests;

  List<DestOt> get destots => _destots;

  //set destot_id(int value) => _destot_id = value;

  set ordretransportId(int value) => _ordretransportId = value;
  set segOrdretransportId(int value) => _segOrdretransportId = value;
  set numOt(String value) => _numOt = value;

  set tracteurImmat(String value) => _tracteurImmat = value;
  set remorqueImmat(String value) => _remorqueImmat = value;
  set dateEnlevement(String value) => _dateEnlevement = value;
  set dateLivraison(String value) => _dateLivraison = value;
  set instruction(String value) => _instruction = value;
  set refCom(String value) => _refCom = value;
  set commentaire(String value) => _commentaire = value;
  set commentaireConducteur(String value) => _commentaireConducteur = value;
  set dateSend(String value) => _dateSend = value;
  set dateRead(String value) => _dateRead = value;

  set donneurordreName(String value) => _donneurordreName = value;
  set donneurordreAddress(String value) => _donneurordreAddress = value;
  set donneurordreAddressComp(String value) => _donneurordreAddressComp = value;
  set donneurordreZipcode(String value) => _donneurordreZipcode = value;
  set donneurordreCity(String value) => _donneurordreCity = value;
  set donneurordreCountry(String value) => _donneurordreCountry = value;
  set expInitialName(String value) => _expInitialName = value;
  set expInitialAddress(String value) => _expInitialAddress = value;
  set expInitialAddressComp(String value) => _expInitialAddressComp = value;
  set expInitialZipcode(String value) => _expInitialZipcode = value;
  set expInitialCity(String value) => _expInitialCity = value;
  set expInitialCountry(String value) => _expInitialCountry = value;
  set destFinalName(String value) => _destFinalName = value;
  set destFinalAddress(String value) => _destFinalAddress = value;
  set destFinalAddressComp(String value) => _destFinalAddressComp = value;
  set destFinalZipcode(String value) => _destFinalZipcode = value;
  set destFinalCity(String value) => _destFinalCity = value;
  set destFinalCountry(String value) => _destFinalCountry = value;
  set isDeleted(bool value) => _isDeleted = value;
  set isClonable(bool value) => _isClonable = value;
  set nbDdests(int value) => _nbDests = value;

  set tourneeId(int value) => _tourneeId = value;
  set sensEnl(int value) => _sensEnl = value;

  //set destots(DestOt value) => _destots[] = value;

  // create the user object from json input
  OrdreTransport.fromJson(Map<String, dynamic> json) {
    _ordretransportId = int.parse(json['ordretransport_id']);
    _segOrdretransportId = int.parse(json['seg_ordretransport_id']);
    _numOt = json['num_ot'];

    _tracteurImmat = json['tracteur_immat'];
    _remorqueImmat = json['remorque_immat'];
    _dateEnlevement = json['date_enlevement'];
    _dateLivraison = json['date_livraison'];
    _instruction = json['instruction'];
    _refCom = json['ref_com'];
    _commentaire = json['commentaire'];
    _commentaireConducteur = json['commentaire_conducteur'];
    _dateSend = json['date_send'];
    _dateRead = json['date_read'];

    _donneurordreName = json['donneurordre_name'];
    _donneurordreAddress = json['donneurordre_address'];
    _donneurordreAddressComp = json['donneurordre_address_comp'];
    _donneurordreZipcode = json['donneurordre_zipcode'];
    _donneurordreCity = json['donneurordre_city'];
    _donneurordreCountry = json['donneurordre_country'];
    _expInitialName = json['exp_initial_name'].toString();
    _expInitialAddress = json['exp_initial_address'].toString();
    _expInitialAddressComp = json['exp_initial_address_comp'].toString();
    _expInitialZipcode = json['exp_initial_zipcode'].toString();
    _expInitialCity = json['exp_initial_city'].toString();
    _expInitialCountry = json['exp_initial_country'].toString();
    _destFinalName = json['dest_final_name'].toString();
    _destFinalAddress = json['dest_final_address'].toString();
    _destFinalAddressComp = json['dest_final_address_comp'].toString();
    _destFinalZipcode = json['dest_final_zipcode'].toString();
    _destFinalCity = json['dest_final_city'].toString();
    _destFinalCountry = json['dest_final_country'].toString();
    _isDeleted = json['is_deleted'] == '1' ? true : false;
    _isClonable = json['is_clonable'] == '1' ? true : false;
    _nbDests = int.parse(json['nb_dests']);
    _tourneeId = json['tournee_id'] != null ? int.parse(json['tournee_id']) : 0;
    _sensEnl = json['sens_enl'] != null ? int.parse(json['sens_enl']) : 0;
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['ordretransport_id'] = _ordretransportId;
    data['seg_ordretransport_id'] = _segOrdretransportId;
    data['num_ot'] = _numOt;

    data['tracteur_immat'] = _tracteurImmat;
    data['remorque_immat'] = _remorqueImmat;
    data['date_enlevement'] = _dateEnlevement;
    data['date_livraison'] = _dateLivraison;
    data['instruction'] = _instruction;
    data['ref_com'] = _refCom;
    data['commentaire'] = _commentaire;
    data['commentaire_conducteur'] = _commentaireConducteur;
    data['date_send'] = _dateSend;
    data['date_read'] = _dateRead;

    data['donneurordre_name'] = _donneurordreName;
    data['donneurordre_address'] = _donneurordreAddress;
    data['donneurordre_address_comp'] = _donneurordreAddressComp;
    data['donneurordre_zipcode'] = _donneurordreZipcode;
    data['donneurordre_city'] = _donneurordreCity;
    data['donneurordre_country'] = _donneurordreCountry;
    data['exp_initial_name'] = _expInitialName;
    data['exp_initial_address'] = _expInitialAddress;
    data['exp_initial_address_comp'] = _expInitialAddressComp;
    data['exp_initial_zipcode'] = _expInitialZipcode;
    data['exp_initial_city'] = _expInitialCity;
    data['exp_initial_country'] = _expInitialCountry;
    data['dest_final_name'] = _destFinalName;
    data['dest_final_address'] = _destFinalAddress;
    data['dest_final_address_comp'] = _destFinalAddressComp;
    data['dest_final_zipcode'] = _destFinalZipcode;
    data['dest_final_city'] = _destFinalCity;
    data['dest_final_country'] = _destFinalCountry;
    data['is_deleted'] = _isDeleted;
    data['is_clonable'] = _isClonable;
    data['nb_dests'] = _nbDests;

    data['tournee_id'] = _tourneeId;
    data['sens_enl'] = _sensEnl;

    return data;
  }

  OrdreTransport fromBdd(Map<String, dynamic> json) {
    _ordretransportId = json['ordretransport_id'];
    _segOrdretransportId = json['seg_ordretransport_id'];
    _numOt = json['num_ot'];

    _tracteurImmat = json['tracteur_immat'];
    _remorqueImmat = json['remorque_immat'];
    _dateEnlevement = json['date_enlevement'];
    _dateLivraison = json['date_livraison'];
    _instruction = json['instruction'];
    _refCom = json['ref_com'];
    _commentaire = json['commentaire'];
    _commentaireConducteur = json['commentaire_conducteur'];
    _dateSend = json['date_send'];
    _dateRead = json['date_read'];

    _donneurordreName = json['donneurordre_name'];
    _donneurordreAddress = json['donneurordre_address'];
    _donneurordreAddressComp = json['donneurordre_address_comp'];
    _donneurordreZipcode = json['donneurordre_zipcode'];
    _donneurordreCity = json['donneurordre_city'];
    _donneurordreCountry = json['donneurordre_country'];
    _expInitialName = json['exp_initial_name'];
    _expInitialAddress = json['exp_initial_address'];
    _expInitialAddressComp = json['exp_initial_address_comp'];
    _expInitialZipcode = json['exp_initial_zipcode'];
    _expInitialCity = json['exp_initial_city'];
    _expInitialCountry = json['exp_initial_country'];
    _destFinalName = json['dest_final_name'];
    _destFinalAddress = json['dest_final_address'];
    _destFinalAddressComp = json['dest_final_address_comp'];
    _destFinalZipcode = json['dest_final_zipcode'];
    _destFinalCity = json['dest_final_city'];
    _destFinalCountry = json['dest_final_country'];
    _isDeleted = json['is_deleted'] == '1' ? true : false;
    _isClonable = json['is_clonable'] == '1' ? true : false;
    _nbDests = json['nb_dests'];
    _tourneeId = json['tournee_id'];
    _sensEnl = json['sens_enl'];

    return this;
  }

  fetchJobs() async {
    List listeTournee = await Network().getTournee();
    for (var tourneedata in listeTournee) {
      Tournee tournee = Tournee.fromJson(tourneedata);
      final data = tournee.toJson();
      await tournee.add(tournee);
    }
    List liste = await Network().geOrdreTransport();
    //clean();
    for (var ordretransportdata in liste) {
      OrdreTransport ordretransport =
          OrdreTransport.fromJson(ordretransportdata);
      final data = ordretransport.toJson();
      data['is_deleted'] = data['is_deleted'] == 'false' ? 0 : 1;

      await ordretransport.add(ordretransport);

      if (ordretransportdata['trajets'] != null) {
        DestOt destot;

        Map<String, dynamic> dataDestot;
        var emetteur = '';
        var emetteurAddress = '';
        var emetteurZipcode = '';
        var emetteurCity = '';
        var recepteur = '';
        var recepteurAddress = '';
        var recepteurZipcode = '';
        var recepteurCity = '';

        ordretransportdata['trajets'].forEach((song, test) async => {
              if (emetteur == '')
                {
                  emetteur = test['enl_lastname'],
                  emetteurAddress = test['enl_address'],
                  emetteurZipcode = test['enl_zipcode'],
                  emetteurCity = test['enl_city'],
                },
              recepteur = test['liv_lastname'],
              recepteurAddress = test['liv_address'],
              recepteurZipcode = test['liv_zipcode'],
              recepteurCity = test['liv_city'],
              destot = DestOt.fromJson(test),
              destot.ordretransportId = ordretransport.getOrdretransportId,
              dataDestot = destot.toJson(),
              dataDestot['is_deleted'] =
                  dataDestot['is_deleted'] == 'false' ? 0 : 1,
              destot.add(destot)
            });
        await ordretransport.updateStatus(ordretransport.getOrdretransportId);
        if (data['exp_initial_name'] == 'Inconnu' ||
            data['exp_initial_name'] == 'null') {
          ordretransport.update({
            'ordretransport_id': ordretransport.getOrdretransportId,
            'exp_initial_name': emetteur,
            'exp_initial_address': emetteurAddress,
            'exp_initial_zipcode': emetteurZipcode,
            'exp_initial_city': emetteurCity,
          });
        }
        if (data['dest_final_name'] == 'Inconnu' ||
            data['dest_final_name'] == 'null') {
          ordretransport.update({
            'ordretransport_id': ordretransport.getOrdretransportId,
            'dest_final_name': recepteur,
            'dest_final_address': recepteurAddress,
            'dest_final_zipcode': recepteurZipcode,
            'dest_final_city': recepteurCity,
          });
        }
      }
    }
    var myVariables = MyVariables();
    dynamic currentContext = myVariables.getMyCurrentContext;

    if (currentContext != null &&
        currentContext.widget.toString() == 'ExploitationScreen') {
      Navigator.pushNamedAndRemoveUntil(
          currentContext, '/home', ModalRoute.withName('/'));
    }

    return true;
  }

  void clean() async {
    final db = await SQLHelper.db();
    db.update(table, {'is_deleted': 1}, where: ' 1 ');
  }

  updateStatus(int ordretransportId) async {
    List<Map<String, dynamic>> destots =
        await SQLHelper.getDestOts(ordretransportId);
    List statusArr = [];
    var is_clonable = 0;
    for (var element in destots) {
      var datasAdd = [
        element['enl_arrivee'] != '0000-00-00 00:00:00',
        element['enl_depart'] != '0000-00-00 00:00:00',
        element['liv_arrivee'] != '0000-00-00 00:00:00',
        element['liv_depart'] != '0000-00-00 00:00:00',
      ];

      if (element['is_clonable'] == 1) {
        is_clonable = 1;
      }
      statusArr.add(datasAdd);
    }
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(now);

    await update({
      'ordretransport_id': ordretransportId,
      'status': json.encode(statusArr),
      'is_clonable': is_clonable
    });
  }

  touch(int ordretransportId) async {
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(now);

    await update(
        {'date_upd': formattedDate, 'ordretransport_id': ordretransportId});
    Network().synchronise();
  }

  Future<OrdreTransport> getItem() async {
    await updateStatus(_ordretransportId);
    List<Map<String, dynamic>> resultat =
        await SQLHelper.getOt(_ordretransportId);
    if (resultat.isEmpty) {
      return OrdreTransport(ordretransportId: 0);
    }
    OrdreTransport ordretransport = fromBdd(resultat[0]);
    List<Map<String, dynamic>> destots =
        await SQLHelper.getDestOts(_ordretransportId);

    for (var element in destots) {
      DestOt destot = DestOt(destotId: element['destot_id']);

      destot = destot.fromBdd(element);
      ordretransport._destots.add(destot);
    }
    if (ordretransport.getTourneeId != 0) {
      var tournee = Tournee(tourneeId: ordretransport.getTourneeId);
      var infoTournee = await tournee.getOne(ordretransport.getTourneeId);
    }
    return ordretransport;
  }

  @override
  String get primary => _primary;
  @override
  String get table => _table;
}
