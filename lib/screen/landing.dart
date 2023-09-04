import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vialticecmr/utils/MyVariables.dart';


class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _userId = "";

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      _loadUserInfo();
    });
  }

  _loadUserInfo() async {
    var myVariables = MyVariables();
    Map<dynamic, dynamic> args = {};
    args['actual'] = '1';

    _userId = myVariables.getMyObject.getTiersId.toString();

    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
