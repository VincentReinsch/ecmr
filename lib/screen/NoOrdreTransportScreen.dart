import 'package:flutter/material.dart';
import 'package:vialticecmr/utils/blocks.dart';

class NoOrdreTransportScreen extends StatefulWidget {
  const NoOrdreTransportScreen({Key? key}) : super(key: key);

  @override
  _NoOrdreTransportScreenState createState() => _NoOrdreTransportScreenState();
}

class _NoOrdreTransportScreenState extends State<NoOrdreTransportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', ModalRoute.withName('/home'));
          },
        ),
        title: const Text('retour à la liste'),
      ),
      body: const Text('Cet ordre de transport n\'existe pas'),
      persistentFooterButtons: piedpageconnected(context),
    );
  }
}
