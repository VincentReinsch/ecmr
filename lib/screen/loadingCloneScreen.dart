import 'package:flutter/material.dart';
import 'package:vialticecmr/model/ordretransport.dart';
import 'package:vialticecmr/screen/OrdreTransportScreen.dart';
import 'package:vialticecmr/utils/network.dart';

class LoadingCloneScreen extends StatefulWidget {
  final int destot_id;
  final int ordretransport_id;

  const LoadingCloneScreen(
      {Key? key, required this.destot_id, required this.ordretransport_id})
      : super(key: key);

  @override
  _LoadingCloneScreenState createState() => _LoadingCloneScreenState();
}

class _LoadingCloneScreenState extends State<LoadingCloneScreen> {
  @override
  OrdreTransport ordre = OrdreTransport(ordretransportId: 0);
  void initState() {
    super.initState();
    Network().cloneTrajet(destot_id: widget.destot_id).then((value) => {
          ordre.fetchJobs().then((value) => {
                Navigator.pushNamed(
                  context,
                  '/ordre',
                  arguments: OrdreTransportParams(
                    widget.ordretransport_id,
                  ),
                ),
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text('Clonage du trajet...'),
                  ),
                  SizedBox(height: 50),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
