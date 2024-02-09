import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imglib;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vialticecmr/model/admin_user.dart';
import 'package:vialticecmr/model/api_error.dart';
import 'package:vialticecmr/model/api_response.dart';
import 'package:vialticecmr/model/user.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';
//import 'package:device_info_plus/device_info_plus.dart';

class Network {
  final MyVariables _myVariables = MyVariables();
  Future<String> cloneTrajet({required int destot_id}) async {
    final response = await http.post(
      Uri.parse('${_myVariables.getMyObject.getBaseUrl}appliecmr/clonage'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'user_login': _myVariables.getMyObject.getLogin,
        'user_password': _myVariables.getMyObject.getPassword,
        'tiers_id': _myVariables.getMyObject.getTiersId.toString(),
        'destot_id': destot_id.toString()
      },
    );

    var jsonResponse = json.decode(response.body);

    return response.body;
  }

  Future<Map<dynamic, dynamic>> login(
      {required String login, required String password}) async {
    final httpsUri =
        Uri.parse('${_myVariables.getMyObject.getUrl}/appli/login');

    final response = await http.post(
      httpsUri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{'login': login, 'password': password},
    );

    var jsonResponse = json.decode(response.body);

    AdminUser.fromJson(jsonResponse);

    return jsonResponse;
  }

  Future<String?> setUserSignature(String path, String name, String elementType,
      String elementId, String subElementId) async {
    var myVariables = MyVariables();
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${myVariables.getMyObject.getBaseUrl}Appliecmr/sendSignature/'));

    var headers = {'Content-Type': 'application/json'};
    request.headers.addAll(headers);

    var uri = path;

    final bytes = await File(uri).readAsBytes();

    final httpImage = http.MultipartFile.fromBytes('doc_file', bytes,
        filename: 'myImage.png');

    request.files.add(httpImage);

    request.files.add(http.MultipartFile.fromBytes('picture', bytes));
    request.fields['user_login'] = myVariables.getMyObject.getLogin;
    request.fields['user_password'] = myVariables.getMyObject.getPassword;
    request.fields['tiers_id'] = myVariables.getMyObject.getTiersId.toString();
    request.fields['doc_name'] = name;
    request.fields['element_type'] = elementType;
    request.fields['element_id'] = elementId;
    request.fields['sub_element_id'] = subElementId;
    try {
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {});

      response.reasonPhrase;
      myVariables.setConnected(true);
    } on SocketException {
      myVariables.setConnected(false);
    } catch (e) {
      // TODO: handle all other exceptions just in case
      myVariables.setConnected(false);
    }
    return null;
  }

  Future<ApiResponse> getUserInfos(
      {required String login, required String password}) async {
    var myVariables = MyVariables();

    int timeout = 5;

    ApiResponse apiResponse = ApiResponse();

    try {
      final response = await http.post(
          Uri.parse(
              '${myVariables.getMyObject.getBaseUrl}Appliecmr/getNameTiers/'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
            'Access-Control-Allow-Origin': '*',
          },
          body: <String, String>{
            'user_login': login,
            'user_password': password,
            'tiers_id': myVariables.getMyObject.getTiersId.toString(),
          }).timeout(const Duration(seconds: 5));

      switch (response.statusCode) {
        case 200:
          var data = json.decode(response.body);

          if (data['error'] == '') {
            data['params']['login'] = myVariables.getMyObject.getLogin;
            data['params']['password'] = myVariables.getMyObject.getPassword;
            //data['params']['tiers_id'] = response.body;
            data['params']['base_url'] = myVariables.getMyObject.getBaseUrl;
            data['params']['actual'] = 1;
            apiResponse.Data = User.fromJson(data);
          } else {
            apiResponse.setApiError = ApiError.fromJson(data);
          }
          break;
        case 401:
          apiResponse.setApiError =
              ApiError.fromJson(json.decode(response.body));
          break;
        default:
          apiResponse.setApiError =
              ApiError(error: "Server error. Please retry");
          break;
      }
      myVariables.setConnected(true);
    } on TimeoutException {
      // handle timeout

      apiResponse.setApiError = ApiError(error: "Server error. Please retry");
    } on SocketException {
      apiResponse.setApiError = ApiError(error: "Server error. Please retry");
      myVariables.setConnected(false);
    } on Error catch (e) {
    } catch (e) {
      myVariables.setConnected(false);
// TODO: handle all other exceptions just in case
    }
    return apiResponse;
  }

  Future<List> getTournee() async {
    var myVariables = MyVariables();
    if (myVariables.getMyObject.getBaseUrl == '') {
      return [];
    }

    final httpsUri = Uri.parse(
        '${myVariables.getMyObject.getBaseUrl}Appliecmr/updateTournee/');
    String lastUpd = await SQLHelper.getParameter('last_call');
    if (lastUpd == '') {
      DateTime now = DateTime.now().subtract(const Duration(days: 30));

      var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      lastUpd = formatter.format(now);
    }

    var liste = [];
    try {
      final response = await http.post(httpsUri, headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: <String, String>{
        'user_login': myVariables.getMyObject.getLogin,
        'user_password': myVariables.getMyObject.getPassword,
        'tiers_id': myVariables.getMyObject.getTiersId.toString(),
        'last_upd': lastUpd,
      });

      dynamic jsonResponse = {};

      try {
        jsonResponse = json.decode(response.body);
      } catch (e) {}
      print('tournees');
      print(jsonResponse);
      if (jsonResponse['objects'] != null) {
        jsonResponse['objects'].forEach((song, test) async => {
              liste.add(test),
            });
        print('ok pou rliste');
        return liste;
      }
      myVariables.setConnected(true);
      //
      print('ok pou rliste vide');
      return liste;
    } on SocketException {
      print('socket');
      myVariables.setConnected(false);
    } catch (e) {
      print('catch');
      myVariables.setConnected(false);
      // TODO: handle all other exceptions just in case
    }
    print('ok pou rliste');
    return liste;
  }

  Future<List> geOrdreTransport() async {
    var myVariables = MyVariables();
    if (myVariables.getMyObject.getBaseUrl == '') {
      return [];
    }

    final httpsUri = myVariables.getMyObject.getBaseUrl.contains('https')
        ? Uri(
            scheme: 'https',
            host: myVariables.getMyObject.getBaseUrl
                .replaceAll('https://', '')
                .replaceAll('/', ''),
            path: '/Appliecmr/updateTransport/',
            fragment: '',
          )
        : Uri(
            scheme: 'http',
            host: myVariables.getMyObject.getBaseUrl
                .replaceAll('http://', '')
                .replaceAll('/', ''),
            path: '/Appliecmr/updateTransport/',
            fragment: '',
          );
    var liste = [];
    try {
      final response = await http.post(httpsUri, headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: <String, String>{
        'user_login': myVariables.getMyObject.getLogin,
        'user_password': myVariables.getMyObject.getPassword,
        'tiers_id': myVariables.getMyObject.getTiersId.toString(),
        'last_upd': await SQLHelper.getParameter('last_call'),
      });

      dynamic jsonResponse = {};
      try {
        jsonResponse = json.decode(response.body);
      } catch (e) {}

      var liste = [];
      if (jsonResponse['objects'] != null) {
        jsonResponse['objects'].forEach((song, test) async => {
              liste.add(test),
            });
        DateTime now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        String formattedDate = formatter.format(now);

        await SQLHelper.setParameter('last_call', formattedDate);

        return liste;
      }
      myVariables.setConnected(true);
      //
      return liste;
    } on SocketException {
      myVariables.setConnected(false);
    } catch (e) {
      myVariables.setConnected(false);
      // TODO: handle all other exceptions just in case
    }
    return liste;
  }

  Future sendCmr(file, destotId, ordretransportId) async {
    var myVariables = MyVariables();
    final cmd = imglib.Command()
      ..decodeImageFile(file)
      ..copyResize(width: 1500)
      ..encodeJpg(quality: 60)
      ..writeToFile('${myVariables.getMyPath}thumbnail.jpg');
    await cmd.executeThread();
    final bytes =
        await File('${myVariables.getMyPath}thumbnail.jpg').readAsBytes();

    if (myVariables.getMyObject.getBaseUrl != '') {
      file = file.replaceAll('DOCUMENT_SCAN', 'scan_');

      Map<String, String> body = {
        'user_login': myVariables.getMyObject.getLogin,
        'user_password': myVariables.getMyObject.getPassword,
        'tiers_id': myVariables.getMyObject.getTiersId.toString(),
        'ot_cmr_id_0': '0',
        'ext_ordretransport_id_0': '',
        'file_content_0': base64Encode(bytes),
        'filepath_0': file,
        'destot_id_0': destotId.toString(),
        'ordretransport_id_0': ordretransportId.toString()
      };

      var test = await http.post(
        Uri.parse('${myVariables.getMyObject.getBaseUrl}Appli/sendCMRs/'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      myVariables.setConnected(true);
    }
  }

  Future setFireBaseToken(token) async {
    var myVariables = MyVariables();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Map<String, String> body = {
      'user_login': myVariables.getMyObject.getLogin,
      'user_password': myVariables.getMyObject.getPassword,
      'tiers_id': myVariables.getMyObject.getTiersId.toString(),
      'token': token,
      'android_version': 'androidInfo.version.release',
      'app_version_name': packageInfo.version,
      'app_version_code': packageInfo.version,
      'device_name': 'androidInfo.model',
      'appli_name': 'vialticecmr'
    };

    try {
      await http.post(
        Uri.parse(
            '${myVariables.getMyObject.getBaseUrl}Appliecmr/sendFirebaseToken/'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      await SQLHelper.setLastDate();
    } on SocketException {
    } catch (e) {
      // TODO: handle all other exceptions just in case
    }
  }

  Future synchronise() async {
    var myVariables = MyVariables();

    if (myVariables.getMyObject.getBaseUrl != '' &&
        myVariables.getMyObject.getTiersId.toString() != 0) {
      String lastDate = await SQLHelper.gettLastDate();
      List params = [];

      if (lastDate != '') {
        params.add({'field': 'date_upd', 'operator': '>', 'value': lastDate});
      }
      final response = await SQLHelper.getItems(params, null);
      Map<String, String> body = {
        'user_login': myVariables.getMyObject.getLogin,
        'user_password': myVariables.getMyObject.getPassword,
        'tiers_id': myVariables.getMyObject.getTiersId.toString(),
        'ext_ordretransport_id_0': '1'
      };

      var ordres = {};
      for (var element in response) {
        final dests = await SQLHelper.getDestOts(element['ordretransport_id']);
        List destOts = [];
        for (var destot in dests) {
          var bodyDestot = {
            'ext_destot_id': destot['destot_id'].toString(),
            'enl_arrivee': destot['enl_arrivee'],
            'enl_depart': destot['enl_depart'],
            'liv_arrivee': destot['liv_arrivee'],
            'liv_depart': destot['liv_depart'],
            'enl_arrivee_latitude': destot['enl_arrivee_latitude'],
            'enl_arrivee_longitude': destot['enl_arrivee_longitude'],
            'enl_depart_latitude': destot['enl_depart_latitude'],
            'enl_depart_longitude': destot['enl_depart_longitude'],
            'liv_arrivee_latitude': destot['liv_arrivee_latitude'],
            'liv_arrivee_longitude': destot['liv_arrivee_longitude'],
            'liv_depart_latitude': destot['liv_depart_latitude'],
            'destot_additionnal_fields': destot['additionnalFieldsTxt'],
            'destot_emballages': destot['emballages'],
            'nb_emballages': destot['quantite'],
            // 'dest_signature': destot['dest_signature'],
            //'exp_signature': destot['exp_signature'],
            'dest_signature_nom': destot['dest_signature_nom'],
            'exp_signature_nom': destot['exp_signature_nom'],
            'dest_reserves': destot['dest_reserves'],
            'exp_reserves': destot['exp_reserves'],
            'last_upd': '2023-01-01'
          };

          destOts.add(bodyDestot);
        }
        /*var ordretransportId = element['seg_ordretransport_id'] != 0
            ? element['seg_ordretransport_id'].toString()
            : element['ordretransport_id'].toString();*/
        var ordretransportId = element['ordretransport_id'].toString();
        ordres[ordretransportId] = {};
        ordres[ordretransportId]['ext_ordretransport_id'] = ordretransportId;

        ordres[ordretransportId]['destots'] = destOts;
      }

      body['ordres'] = json.encode(ordres);
      try {
        await http.post(
          Uri.parse(
              '${myVariables.getMyObject.getBaseUrl}Appliecmr/sendTransports/'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body,
        );
        myVariables.setConnected(true);
        await SQLHelper.setLastDate();
      } on SocketException {
        myVariables.setConnected(false);
      } catch (e) {
        myVariables.setConnected(false);
        // TODO: handle all other exceptions just in case
      }
    } else {}
  }
}
