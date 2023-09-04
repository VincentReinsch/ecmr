import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vialticecmr/model/tournee.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/blocks.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';
import 'package:vialticecmr/utils/blocks.dart' as blocks;

class TourneeParams {
  final int tourneeId;

  TourneeParams(this.tourneeId);
}

class TourneeLandingScreen extends StatefulWidget {
  final int tourneeId;

  const TourneeLandingScreen({Key? key, required this.tourneeId})
      : super(key: key);

  @override
  _TourneeScreenLandingState createState() => _TourneeScreenLandingState();
}

class _TourneeScreenLandingState extends State<TourneeLandingScreen> {
  @override
  void initState() {
    super.initState();

    getTourneeInfos();
  }

  getTourneeInfos() async {
    var tournee = Tournee(tourneeId: widget.tourneeId);
    tournee = await tournee.getItem();
    if (tournee.getTourneeId == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const NoTourneeScreen(),
          ),
          ModalRoute.withName('/'));
    } else {
      List params = [];
      params.add({'field': 'is_deleted', 'value': 0});
      params.add(
          {'field': 'ordre_transport.tournee_id', 'value': widget.tourneeId});
      var ordres =
          await SQLHelper.getItems(params, {'by': 'sens_enl', 'sort': 'ASC'});

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TourneeScreen(tournee: tournee, ordres: ordres),
          ),
          ModalRoute.withName('/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    var myVariables = MyVariables();
    myVariables.setCurrentContext(context);
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class NoTourneeScreen extends StatefulWidget {
  const NoTourneeScreen({Key? key}) : super(key: key);

  @override
  _NoTourneeScreenState createState() => _NoTourneeScreenState();
}

class _NoTourneeScreenState extends State<NoTourneeScreen> {
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
      body: const Text('Cette tournée n\'existe pas'),
      persistentFooterButtons: piedpageconnected(context),
    );
  }
}

class TourneeScreen extends StatefulWidget {
  final Tournee tournee;
  final List ordres;

  const TourneeScreen({Key? key, required this.tournee, required this.ordres})
      : super(key: key);

  @override
  _TourneeScreenState createState() => _TourneeScreenState();
}

class _TourneeScreenState extends State<TourneeScreen> {
  @override
  void initState() {
    super.initState();
  }

  ListView _jobsListView(data, context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return blocks.tile(data[index]['num_ot'], data[index]['ref_com'],
              Icons.work, data[index], context);
        });
  }

  @override
  Widget build(BuildContext context) {
    var myVariables = MyVariables();
    myVariables.setCurrentContext(context);
    DateTime debut = DateTime.parse(widget.tournee.getDebutTournee.toString());
    DateTime fin = DateTime.parse(widget.tournee.getDebutTournee)
        .add(Duration(days: widget.tournee.getNbDay - 1));

    var formatter = DateFormat('dd/MM/yyyy');

    var finTournee = '${formatter.format(fin)} ${widget.tournee.getHourFin}';
    var debutTournee =
        '${formatter.format(debut)} ${widget.tournee.getHourDeb}';
    //Determination des trajets
    int nbTrajet = widget.ordres.length;

    //Construction tu tableau
    List<Widget> tabTrajet = [];
    List<Widget> tabTrajetTab = [];
    bool isSet = false;
    for (var i = 0; i < nbTrajet; i++) {
      if (widget.ordres[i]['status'] == '[[true,true,true,true]]' || isSet) {
        tabTrajetTab.add(const Text(textAlign: TextAlign.center, ''));
        isSet = false || isSet;
      } else {
        tabTrajetTab.add(const Icon(Icons.arrow_drop_down));
        isSet = true;
      }

      tabTrajet.add(Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Text(textAlign: TextAlign.center, (i + 1).toString())));
    }
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Center(
                    child: Text(
                      'TOURNEE - ${widget.tournee.getCodeTournee}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  color: Colors.white,
                  child: Center(
                      child: Column(
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: tabTrajetTab,
                          ),
                          TableRow(
                            children: tabTrajet,
                          )
                        ],
                      ),
                      Table(
                        children: [
                          TableRow(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Début:'),
                                    Text(debutTournee)
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Fin:'),
                                    Text(finTournee)
                                  ])
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                children: [
                  Text('Transports de la tournée'),
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _jobsListView(widget.ordres, context),
            ),
          ),
        ],
      ),
      persistentFooterButtons: piedpageconnected(context),
    );
  }
}
