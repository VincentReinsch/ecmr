import 'dart:convert';

import 'package:vialticecmr/model/abstract_model.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';

import 'ordretransport.dart';

class Emballage {
  String _emballageId = '0';
  String _emballageName = '';
  String _quantite = '0';
  Emballage(Map element) {
    _emballageId = element['emballage_id'];
    _emballageName = element['emballage_name'];
    _quantite = element['quantite'];
  }
  String get getEmballageId => _emballageId;
  String get getEmballageName => _emballageName;
  String get getQuantite => _quantite;

  set quantite(String value) => _quantite = value;
}

String dOEmbToJson(List<Emballage> value) {
  var data = [];
  for (var element in value) {
    data.add(dOEmbfromJson(element));
  }

  return json.encode(data);
}

Map dOEmbfromJson(Emballage element) {
  var retour = {
    'emballage_id': element._emballageId,
    'quantite': element._quantite,
    'emballage_name': element._emballageName
  };
  return retour;
}

class DestOtAdditionnalField {
  String _id = '';
  String _name = '';
  String _type = '';
  String _value = '';
  String _params = '';
  String _parent = '';
  DestOtAdditionnalField(Map element) {
    _id = element['id'];
    _name = element['name'];
    _type = element['type'];
    _params = element['params'];
    _value = element['value'];
    _parent = element['parent'].toString();
  }
  String get getId => _id;
  String get getName => _name;
  String get getType => _type;
  String get getValue => _value;

  String get getParams => _params;
  String get getParent => _parent;

  set setValue(String value) => _value = value;
}

String dOAIToJson(List<DestOtAdditionnalField> value) {
  var data = [];
  for (var element in value) {
    data.add(dOAIfromJson(element));
  }

  return json.encode(data);
}

Map dOAIfromJson(DestOtAdditionnalField element) {
  var retour = {
    'id': element._id,
    'name': element._name,
    'type': element._type,
    'value': element._value,
    'params': element._params,
    'parent': element._parent
  };
  return retour;
}

class DestOt extends AbstractModel {
  final _table = 'destot';
  final _primary = 'destot_id';
  int _destotId = 0;

  int _poids = 0;
  double _hectolitre = 0.00;
  double _metre = 0.00;
  bool _isDeleted = false;
  bool _isClonable = false;
  String _dateEnlevement = '00-00-00 00:00:00';
  String _dateLivraison = '0000-00-00 00:00:00';

  String _refLiv = '';
  String _impLiv = '';

  String _enlArrivee = '2023-01-27 10:00:00';
  String _enlDepart = '0000-00-00 00:00:00';
  String _livArrivee = '0000-00-00 00:00:00';
  String _livDepart = '0000-00-00 00:00:00';
  String _natureMarchandise = '';
  int _ordretransportId = 0;
  String _enlArriveeLatitude = '0.00000000';
  String _enlArriveeLongitude = '0.00000000';
  String _enlDepartLatitude = '0.00000000';
  String _enlDepartLongitude = '0.00000000';
  String _livArriveeLatitude = '0.00000000';
  String _livArriveeLongitude = '0.00000000';
  String _livDepartLatitude = '0.00000000';
  String _livDepartLongitude = '0.00000000';
  String _destotName = '';

  int _quantite = 0;
  String _emballageName = 'palette';
  String _emballagesTxt = '';
  String _additionnalFieldsTxt = '';

  String _enlPhone = '';
  String _enlLastname = '';
  String _enlAddress = '';
  String _enlAddressComp = '';
  String _enlZipcode = '';
  String _enlCity = '';
  String _enlCountryName = '';

  String _livPhone = '';
  String _livLastname = '';
  String _livAddress = '';
  String _livAddressComp = '';
  String _livZipcode = '';
  String _livCity = '';
  String _livCountryName = '';

  String _destSignature = '';
  String _destSignatureNom = '';
  String _destReserves = '';
  String _expSignature = '';
  String _expSignatureNom = '';
  String _expReserves = '';

  String _tracteurImmat = '';
  String _remorqueImmat = '';

  List<DestOtAdditionnalField> _additionnalFields = [];
  List<Emballage> _emballages = [];

  // constructor
  DestOt({
    required int destotId,
    int ordretransportId = 0,
    int quantite = 0,
    int poids = 0,
    double hectolitre = 0.00,
    double metre = 0.00,
    bool isDeleted = false,
    bool isClonable = false,
    String dateEnlevement = '00-00-00 00:00:00',
    String dateLivraison = '0000-00-00 00:00:00',
    String refLiv = '',
    String impLiv = '',
    String enlArrivee = '0000-00-00 00:00:00',
    String enlDepart = '0000-00-00 00:00:00',
    String livArrivee = '0000-00-00 00:00:00',
    String livDepart = '0000-00-00 00:00:00',
    String natureMarchandise = '',
    String enlArriveeLatitude = '0.00000000',
    String enlArriveeLongitude = '0.00000000',
    String enlDepartLatitude = '0.00000000',
    String enlDepartLongitude = '0.00000000',
    String livArriveeLatitude = '0.00000000',
    String livArriveeLongitude = '0.00000000',
    String livDepartLatitude = '0.00000000',
    String livDepartLongitude = '0.00000000',
    String destotName = '',
    String emballageName = '',
    String enlPhone = '',
    String enlLastname = '',
    String enlAddress = '',
    String enlAddressComp = '',
    String enlZipcode = '',
    String enlCity = '',
    String enlCountryName = '',
    String livPhone = '',
    String livLastname = '',
    String livAddress = '',
    String livAddressComp = '',
    String livZipcode = '',
    String livCity = '',
    String livCountryName = '',
    String destSignature = '',
    String destSignatureNom = '',
    String destReserves = '',
    String expSignature = '',
    String expSignatureNom = '',
    String expReserves = '',
    String tracteurImmat = '',
    String remorqueImmat = '',
  }) {
    _destotId = destotId;

    _quantite = quantite;
    _poids = poids;
    _hectolitre = hectolitre;
    _metre = metre;
    _isDeleted = isDeleted;
    _isClonable = isClonable;
    _dateEnlevement = dateEnlevement;
    _dateLivraison = dateLivraison;

    _refLiv = refLiv;
    _impLiv = impLiv;

    _enlArrivee = enlArrivee;
    _enlDepart = enlDepart;
    _livArrivee = livArrivee;
    _livDepart = livDepart;
    _natureMarchandise = natureMarchandise;
    _ordretransportId = ordretransportId;
    _enlArriveeLatitude = enlArriveeLatitude;
    _enlArriveeLongitude = enlArriveeLongitude;
    _enlDepartLatitude = enlDepartLatitude;
    _enlDepartLongitude = enlDepartLongitude;
    _livArriveeLatitude = livArriveeLatitude;
    _livArriveeLongitude = livArriveeLongitude;
    _livDepartLatitude = livDepartLatitude;
    _livDepartLongitude = livDepartLongitude;
    _destotName = destotName;
    _emballageName = emballageName;

    _enlPhone = enlPhone;
    _enlLastname = enlLastname;
    _enlAddress = enlAddress;
    _enlAddressComp = enlAddressComp;
    _enlZipcode = enlZipcode;
    _enlCity = enlCity;
    _enlCountryName = enlCountryName;

    _livPhone = livPhone;
    _livLastname = livLastname;
    _livAddress = livAddress;
    _livAddressComp = livAddressComp;
    _livZipcode = livZipcode;
    _livCity = livCity;
    _livCountryName = livCountryName;

    _destSignature = destSignature;
    _destSignatureNom = destSignatureNom;
    _destReserves = destReserves;
    _expSignature = expSignature;
    _expSignatureNom = expSignatureNom;
    _expReserves = expReserves;
    _tracteurImmat = tracteurImmat;
    _remorqueImmat = remorqueImmat;
  }

  int get getDestotId => _destotId;

  int get getQuantite => _quantite;
  int get getPoids => _poids;
  double get getHectolitre => _hectolitre;
  double get getMetre => _metre;
  bool get getIsDeleted => _isDeleted;
  bool get getIsClonable => _isClonable;
  String get getDateEnlevement => _dateEnlevement;
  String get getDateLivraison => _dateLivraison;

  String get getRefLiv => _refLiv;
  String get getImpLiv => _impLiv;

  String get getEnlArrivee => _enlArrivee;
  String get getEnlDepart => _enlDepart;
  String get getLivArrivee => _livArrivee;
  String get getLivDepart => _livDepart;
  String get getNatureMarchandise => _natureMarchandise;
  int get getOrdretransportId => _ordretransportId;
  String get getEnlArriveeLatitude => _enlArriveeLatitude;
  String get getEnlArriveeLongitude => _enlArriveeLongitude;
  String get getEnlDepartLatitude => _enlDepartLatitude;
  String get getEnlDepartLongitude => _enlDepartLongitude;
  String get getLivArriveeLatitude => _livArriveeLatitude;
  String get getLivArriveeLongitude => _livArriveeLongitude;
  String get getLivDepartLatitude => _livDepartLatitude;
  String get getLivDepartLongitude => _livDepartLongitude;
  String get getDestotName => _destotName;
  String get getEmballageName => _emballageName;

  String get getEnlPhone => _enlPhone;
  String get getEnlLastname => _enlLastname;
  String get getEnlAddress => _enlAddress;
  String get getEnlAddressComp => _enlAddressComp;
  String get getEnlZipcode => _enlZipcode;
  String get getEnlCity => _enlCity;
  String get getEnlCountryName => _enlCountryName;

  String get getLivPhone => _livPhone;
  String get getLivLastname => _livLastname;
  String get getLivAddress => _livAddress;
  String get getLivAddressComp => _livAddressComp;
  String get getLivZipcode => _livZipcode;
  String get getLivCity => _livCity;
  String get getLivCountryName => _livCountryName;

  String get destSignature => _destSignature;
  String get destSignatureNom => _destSignatureNom;
  String get destReserves => _destReserves;
  String get expSignature => _expSignature;
  String get expSignatureNom => _expSignatureNom;
  String get expReserves => _expReserves;

  String get getTracteurImmat => _tracteurImmat;
  String get getRemorqueImmat => _remorqueImmat;

  List<Emballage> get getEmballages => _emballages;
  List<DestOtAdditionnalField> get getAdditionnalFields => _additionnalFields;

  String get getAdditionnalFieldsTxt => _additionnalFieldsTxt;

  set destot_id(int value) => _destotId = value;

  set quantite(int value) => _quantite = value;
  set poids(int value) => _poids = value;
  set hectolitre(double value) => _hectolitre = value;

  set metre(double value) => _metre = value;
  set isDeleted(bool value) => _isDeleted = value;
  set isClonable(bool value) => _isClonable = value;
  set dateEnlevement(String value) => _dateEnlevement = value;
  set dateLivraison(String value) => _dateLivraison = value;

  set refLiv(String value) => _refLiv = value;
  set impLiv(String value) => _impLiv = value;

  set enlArrivee(String value) => _enlArrivee = value;
  set enlDepart(String value) => _enlDepart = value;
  set livArrivee(String value) => _livArrivee = value;
  set livDepart(String value) => _livDepart = value;
  set natureMarchandise(String value) => _natureMarchandise = value;
  set ordretransportId(int value) => _ordretransportId = value;
  set enlArriveeLatitude(String value) => _enlArriveeLatitude = value;
  set enlArriveeLongitude(String value) => _enlArriveeLongitude = value;
  set enlDepartLatitude(String value) => _enlDepartLatitude = value;
  set enlDepartLongitude(String value) => _enlDepartLongitude = value;
  set livArriveeLatitude(String value) => _livArriveeLatitude = value;
  set livArriveeLongitude(String value) => _livArriveeLongitude = value;
  set livDepartLatitude(String value) => _livDepartLatitude = value;
  set livDepartLongitude(String value) => _livDepartLongitude = value;
  set destotName(String value) => _destotName = value;
  set emballageName(String value) => _emballageName = value;

  set enlPhone(String value) => _enlPhone = value;
  set enlLastName(String value) => _enlLastname = value;
  set enlAddress(String value) => _enlAddress = value;
  set enlAddressComp(String value) => _enlAddressComp = value;
  set enlZipcode(String value) => _enlZipcode = value;
  set enlCity(String value) => _enlCity = value;
  set enlCountryName(String value) => _enlCountryName = value;

  set livPhone(String value) => _livPhone = value;
  set livLastName(String value) => _livLastname = value;
  set livAddress(String value) => _livAddress = value;
  set livAddressComp(String value) => _livAddressComp = value;
  set livZipcode(String value) => _livZipcode = value;
  set livCity(String value) => _livCity = value;
  set livCountryName(String value) => _livCountryName = value;

  void setDestSignature(String value) => _destSignature = value;
  void setDestSignatureNom(String value) => _destSignatureNom = value;
  void setDestReserves(String value) => _destReserves = value;
  void setExpSignature(String value) => _expSignature = value;
  void setExpSignatureNom(String value) => _expSignatureNom = value;
  void setExpReserves(String value) => _expReserves = value;

  void setTracteurImmat(String value) => _tracteurImmat = value;

  void setRemorqueImmat(String value) => _remorqueImmat = value;

  void setEmballages(List<Emballage> value) =>
      {_emballages = value, _emballagesTxt = dOEmbToJson(value)};

  void setAdditionnalFields(List<DestOtAdditionnalField> value) =>
      {_additionnalFields = value, _additionnalFieldsTxt = dOAIToJson(value)};
  set emballages(List<Emballage> value) => _emballages = value;

  DestOt.fromJson(Map<String, dynamic> jsonData) {
    _destotId = int.parse(jsonData['destot_id']);

    _poids = int.parse(jsonData['poids']);
    _hectolitre = double.parse(jsonData['hectolitre']);
    _metre = double.parse(jsonData['metre']);
    _isDeleted = jsonData['is_deleted'] == '0' ? false : true;

    _isClonable = jsonData['is_clonable'] == 'true';

    _dateEnlevement = jsonData['date_enlevement'];
    _dateLivraison = jsonData['date_livraison'];

    _refLiv = jsonData['ref_liv'];
    _impLiv = jsonData['imp_liv'];

    _enlArrivee = jsonData['enl_arrivee'];
    _enlDepart = jsonData['enl_depart'];
    _livArrivee = jsonData['liv_arrivee'];
    _livDepart = jsonData['liv_depart'];
    _natureMarchandise = jsonData['nature_marchandise'];
    _ordretransportId = int.parse(jsonData['ordretransport_id']);
    _enlArriveeLatitude = jsonData['enl_arrivee_latitude'];
    _enlArriveeLongitude = jsonData['enl_arrivee_longitude'];
    _enlDepartLatitude = jsonData['enl_depart_latitude'];
    _enlDepartLongitude = jsonData['enl_depart_longitude'];
    _livArriveeLatitude = jsonData['liv_arrivee_latitude'];
    _livArriveeLongitude = jsonData['liv_arrivee_longitude'];
    _livDepartLatitude = jsonData['liv_depart_latitude'];
    _livDepartLongitude = jsonData['liv_depart_longitude'];
    _destotName = jsonData['destot_name'];

    _emballageName = jsonData['emballage_name'];
    _quantite = double.parse(jsonData['quantite']).toInt();

    _enlPhone = jsonData['enl_phone'];
    _enlLastname = jsonData['enl_lastname'];
    _enlAddress = jsonData['enl_address'];
    _enlAddressComp = jsonData['enl_address_comp'];
    _enlZipcode = jsonData['enl_zipcode'];
    _enlCity = jsonData['enl_city'];
    _enlCountryName = jsonData['enl_country_name'];

    _livPhone = jsonData['liv_phone'];
    _livLastname = jsonData['liv_lastname'];
    _livAddress = jsonData['liv_address'];
    _livAddressComp = jsonData['liv_address_comp'];
    _livZipcode = jsonData['liv_zipcode'];
    _livCity = jsonData['liv_city'];
    _livCountryName = jsonData['liv_country_name'];

    _destSignature = jsonData['dest_signature'];
    _destSignatureNom = jsonData['dest_signature_nom'];
    _destReserves = jsonData['dest_reserves'];
    _expSignature = jsonData['exp_signature'];
    _expSignatureNom = jsonData['exp_signature_nom'];
    _expReserves = jsonData['exp_reserves'];

    _tracteurImmat = jsonData['tracteur_immat'].toString();
    _remorqueImmat = jsonData['remorque'].toString();
    var data = json.decode(jsonData['additionnalFieldsTxt']);
    data.forEach(
        (element) => {_additionnalFields.add(DestOtAdditionnalField(element))});

    _additionnalFieldsTxt = jsonData['additionnalFieldsTxt'];
    _emballagesTxt = jsonData['emballages'].toString();
  }
  DestOt fromBdd(Map<String, dynamic> jsonData) {
    _destotId = jsonData['destot_id'];
    _quantite = jsonData['quantite'];
    _poids = jsonData['poids'];

    _hectolitre = jsonData['hectolitre'];
    _metre = jsonData['metre'];
    _isDeleted = jsonData['is_deleted'] == '0' ? false : true;
    _isClonable = jsonData['is_clonable'] == 0 ? false : true;
    _dateEnlevement = jsonData['date_enlevement'];
    _dateLivraison = jsonData['date_livraison'];

    _refLiv = jsonData['ref_liv'];
    _impLiv = jsonData['imp_liv'];

    _enlArrivee = jsonData['enl_arrivee'];
    _enlDepart = jsonData['enl_depart'];
    _livArrivee = jsonData['liv_arrivee'];
    _livDepart = jsonData['liv_depart'];
    _natureMarchandise = jsonData['nature_marchandise'];
    _ordretransportId = jsonData['ordretransport_id'];
    _enlArriveeLatitude = jsonData['enl_arrivee_latitude'];
    _enlArriveeLongitude = jsonData['enl_arrivee_longitude'];
    _enlDepartLatitude = jsonData['enl_depart_latitude'];
    _enlDepartLongitude = jsonData['enl_depart_longitude'];
    _livArriveeLatitude = jsonData['liv_arrivee_latitude'];
    _livArriveeLongitude = jsonData['liv_arrivee_longitude'];
    _livDepartLatitude = jsonData['liv_depart_latitude'];
    _livDepartLongitude = jsonData['liv_depart_longitude'];
    _destotName = jsonData['destot_name'];
    _emballageName = jsonData['emballage_name'];
    print('Emballages');
    print(jsonData['emballages']);
    var data_emb = json.decode(jsonData['emballages']);

    data_emb.forEach((element) => {_emballages.add(Emballage(element))});

    //print(jsonData['emballages']);
    _enlPhone = jsonData['enl_phone'];
    _enlLastname = jsonData['enl_lastname'];
    _enlAddress = jsonData['enl_address'];
    _enlAddressComp = jsonData['enl_address_comp'];
    _enlZipcode = jsonData['enl_zipcode'];
    _enlCity = jsonData['enl_city'];
    _enlCountryName = jsonData['enl_country_name'];

    _livPhone = jsonData['liv_phone'];
    _livLastname = jsonData['liv_lastname'];
    _livAddress = jsonData['liv_address'];
    _livAddressComp = jsonData['liv_address_comp'];
    _livZipcode = jsonData['liv_zipcode'];
    _livCity = jsonData['liv_city'];
    _livCountryName = jsonData['liv_country_name'];

    _destSignature = jsonData['dest_signature'];
    _destSignatureNom = jsonData['dest_signature_nom'];
    _destReserves = jsonData['dest_reserves'];
    _expSignature = jsonData['exp_signature'];
    _expSignatureNom = jsonData['exp_signature_nom'];
    _expReserves = jsonData['exp_reserves'];

    _tracteurImmat = jsonData['tracteur_immat'].toString();
    _remorqueImmat = jsonData['remorque'].toString();

    _additionnalFieldsTxt = jsonData['additionnalFieldsTxt'];

    var data = json.decode(jsonData['additionnalFieldsTxt']);
    data.forEach(
        (element) => {_additionnalFields.add(DestOtAdditionnalField(element))});

    return this;
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['destot_id'] = _destotId;

    data['quantite'] = _quantite;
    data['poids'] = _poids;
    data['hectolitre'] = _hectolitre;
    data['metre'] = _metre;
    data['is_deleted'] = _isDeleted;
    data['is_clonable'] = _isClonable;
    data['date_enlevement'] = _dateEnlevement;
    data['date_livraison'] = _dateLivraison;

    data['ref_liv'] = _refLiv;
    data['imp_liv'] = _impLiv;

    data['enl_arrivee'] = _enlArrivee;
    data['enl_depart'] = _enlDepart;
    data['liv_arrivee'] = _livArrivee;
    data['liv_depart'] = _livDepart;
    data['nature_marchandise'] = _natureMarchandise;
    data['ordretransport_id'] = _ordretransportId;
    data['enl_arrivee_latitude'] = _enlArriveeLatitude;
    data['enl_arrivee_longitude'] = _enlArriveeLongitude;
    data['enl_depart_latitude'] = _enlDepartLatitude;
    data['enl_depart_longitude'] = _enlDepartLongitude;
    data['liv_arrivee_latitude'] = _livArriveeLatitude;
    data['liv_arrivee_longitude'] = _livArriveeLongitude;
    data['liv_depart_latitude'] = _livDepartLatitude;
    data['liv_depart_longitude'] = _livDepartLongitude;
    data['destot_name'] = _destotName;
    data['emballage_name'] = _emballageName;

    data['enl_phone'] = _enlPhone;
    data['enl_lastname'] = _enlLastname;
    data['enl_address'] = _enlAddress;
    data['enl_address_comp'] = _enlAddressComp;
    data['enl_zipcode'] = _enlZipcode;
    data['enl_city'] = _enlCity;
    data['enl_country_name'] = _enlCountryName;

    data['liv_phone'] = _livPhone;
    data['liv_lastname'] = _livLastname;
    data['liv_address'] = _livAddress;
    data['liv_address_comp'] = _livAddressComp;
    data['liv_zipcode'] = _livZipcode;
    data['liv_city'] = _livCity;
    data['liv_country_name'] = _livCountryName;

    data['dest_signature'] = _destSignature;
    data['dest_signature_nom'] = _destSignatureNom;
    data['dest_reserves'] = _destReserves;
    data['exp_signature'] = _expSignature;
    data['exp_signature_nom'] = _expSignatureNom;
    data['exp_reserves'] = _expReserves;
    data['emballages'] = _emballagesTxt;

    data['tracteur_immat'] = _tracteurImmat;
    data['remorque_immat'] = _remorqueImmat;
    data['additionnalFieldsTxt'] = _additionnalFieldsTxt.toString();

    return data;
  }

  Future<DestOt> getItem() async {
    List<Map<String, dynamic>> resultat = await SQLHelper.getDestOt(_destotId);

    return fromBdd(resultat[0]);
  }

  Future<DestOt> setItem(DestOt destot) async {
    await SQLHelper.setDestOt(destot);

    var ordre = OrdreTransport(ordretransportId: 0);
    ordre.updateStatus(destot.getOrdretransportId);
    ordre.touch(destot.getOrdretransportId);
    return destot;
  }

  void setAdditionnalFieldsTxt(String encode) {
    _additionnalFieldsTxt = encode;
  }

  void setEmballagesTxt(String encode) {
    _emballagesTxt = encode;
  }

  @override
  String get primary => _primary;
  @override
  String get table => _table;
}
