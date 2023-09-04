import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vialticecmr/model/ordretransport.dart';

import 'package:vialticecmr/screen/ExploitationScreen.dart';
import 'package:vialticecmr/screen/ScanPageScreen.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/network.dart';

import 'package:crypto/crypto.dart';
import 'package:scan/scan.dart';
import 'package:images_picker/images_picker.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _platformVersion = 'Unknown';

  String qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    var str = await SQLHelper.getLastBase();
    var myService = MyVariables();
    if (str != '') {
      var dataJson = json.decode(str);
      myService.baseUrl(dataJson['url']);
      myService.baseName(dataJson['base']);
    }

    var login = await SQLHelper.getLastLogin();
    if (login != '') {
      myService.setLogin(login);
    }
    var pass = await SQLHelper.getLastPass();
    if (pass != '') {
      myService.setPass(pass);
    }
    var tiersId = await SQLHelper.getLastTiersId();
    if (tiersId != 0) {
      myService.setTiersId(tiersId);
    }
    if (login != '' && pass != '' && tiersId != 0) {
      Network().setFireBaseToken(myService.token);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ExploitationScreen(),
          ),
          (route) => false);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _login = MyVariables().getMyObject.getLogin;
  String _password = MyVariables().getMyObject.getPassword;

  bool loading_connect = false;
  bool _isSecret = true;

  //
  void _handleSubmitted() async {
    MyVariables myService = MyVariables();
    setState(() {
      loading_connect = true;
    });

    if (_formKey.currentState!.validate()) {
      var bytes = utf8.encode(_password); // data being has
      myService.getMyObject.login = _login;
      myService.getMyObject.password = sha1.convert(bytes).toString();

      var responseUser = await Network().getUserInfos(
        login: _login,
        password: sha1.convert(bytes).toString(),
      );
      if (responseUser.GetApiError.isEmpty()) {
        SQLHelper.setLastLogin(_login);
        SQLHelper.setLastPass(sha1.convert(bytes).toString());

        Network().setFireBaseToken(myService.token);

        myService.setConnect(responseUser.Data);
        OrdreTransport ordre = OrdreTransport(ordretransportId: 0);
        await ordre.fetchJobs();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const ExploitationScreen(),
            ),
            (route) => false);
      } else {
        setState(() {
          loading_connect = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Erreur de login ou de mot de passe, veuillez réessayer'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } else {
      setState(() {
        loading_connect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    MyVariables myService = MyVariables();
    myService.setCurrentContext(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: myService.getMyObject.getBaseUrl == ''
                      ? [
                          Image.asset('assets/img_logo_ecmr.png'),
                          const Text(
                              'Veuillez renseigner le qrcode de votre base'),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            child: const Text("Depuis votre téléphone"),
                            onPressed: () async {
                              List<Media>? res = await ImagesPicker.pick();
                              if (res != null) {
                                String? str = await Scan.parse(res[0].path);

                                if (str != null) {
                                  SQLHelper.setLastBase(str);
                                  var dataJson = json.decode(str);

                                  //print(data_json.base);
                                  myService.baseUrl(dataJson['url']);
                                  myService.baseName(dataJson['base']);

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthScreen(),
                                      ),
                                      (route) => false);
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            child: const Text('En scannant un qr code'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) {
                                  return ScanPage();
                                }),
                              );
                            },
                          ),
                        ]
                      : [
                          Image.asset('assets/img_logo_ecmr.png'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(myService.getMyObject.getBaseName,
                                  style: const TextStyle(fontSize: 20.0)),
                              IconButton(
                                onPressed: () {
                                  myService.baseUrl('');
                                  SQLHelper.setLastBase('');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) {
                                      return const AuthScreen();
                                    }),
                                  );
                                },
                                icon: const Icon(Icons.change_circle),
                              ),
                            ],
                          ),
                          const Text('Veuillez vous connecter'),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            initialValue: myService.getMyObject.getLogin,
                            onChanged: (value) =>
                                setState(() => _login = value),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Veuillez saisir votre login'
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'Tapez votre login',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            initialValue: '',
                            onChanged: (value) =>
                                setState(() => _password = value),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Veuillez saisir votre mot de passe'
                                : null,
                            obscureText: _isSecret,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () =>
                                      setState(() => _isSecret = !_isSecret),
                                  child: Icon(
                                    !_isSecret
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  )),
                              hintText: 'Tapez votre mot de passe',
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          !loading_connect
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(20.0),
                                  ),
                                  onPressed: _handleSubmitted,
                                  child: const Text('SE CONNECTER'),
                                )
                              : const Text('Chargement')
                        ],
                )),
          ),
        ),
      ),
    );
  }
}
