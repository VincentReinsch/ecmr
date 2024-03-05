import 'package:flutter/material.dart';
import 'package:vialticecmr/model/ordretransport.dart';
import 'package:vialticecmr/screen/NoOrdreTransportScreen.dart';
import 'package:vialticecmr/screen/OrdreTransportScreen.dart';

class OrdreTransportLandingScreen extends StatefulWidget {
  final int ordretransportId;

  const OrdreTransportLandingScreen({Key? key, required this.ordretransportId})
      : super(key: key);

  @override
  _OrdreTransportLandingScreenState createState() =>
      _OrdreTransportLandingScreenState();
}

class _OrdreTransportLandingScreenState
    extends State<OrdreTransportLandingScreen> {
  @override
  void initState() {
    super.initState();

    getTrajetInfos();
  }

  getTrajetInfos() async {
    var ordre = OrdreTransport(ordretransportId: widget.ordretransportId);
    print(ordre);
    ordre = await ordre.getItem();
    if (ordre.getOrdretransportId == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NoOrdreTransportScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrdreTransportScreen(ordretransport: ordre),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
