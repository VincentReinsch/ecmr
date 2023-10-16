import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vialticecmr/model/ordretransport.dart';
import 'package:vialticecmr/screen/OrdreTransportScreen.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';

Row iconBlock(
  IconData icon,
  String texte,
  Color? color,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(icon, color: color),
      Flexible(
        child: Text(
          texte,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: const TextStyle(fontSize: 15.0),
        ),
      ),
    ],
  );
}

List<DropdownMenuItem<String>> getItemListFormTxt(String Texte) {
  List items = Texte.split('|');
  List<DropdownMenuItem<String>> retour = [
    DropdownMenuItem<String>(
      value: '',
      child: Text('Valeur par défaut'),
    ),
  ];
  items.forEach((element) {
    retour.add(
      DropdownMenuItem<String>(
        value: element,
        child: Text(element),
      ),
    );
  });
  return retour;
}

List<Widget> piedpageconnected(context) {
  final myService = MyVariables();
  recuperation_ordres() async {
    OrdreTransport ordre = OrdreTransport(ordretransportId: 0);
    await ordre.fetchJobs();
  }

  return [
    IconButton(
        icon: Icon(Icons.circle,
            color: myService.getConnected == true ? Colors.green : Colors.red),
        onPressed: () {}),
    Text(MyVariables().infoversion),
    Text(
        '${myService.getMyObject.getFirstName} ${myService.getMyObject.getLastName}'),
    IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.exit_to_app,
      ),
      onPressed: () {
        SQLHelper.cleanTables();
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', ModalRoute.withName('/login'));
      },
    ),
    IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.settings,
      ),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/account',
          ModalRoute.withName('/'),
        );
      },
    )
  ];
}

Material tile(
    String? title, String? subtitle, IconData icon, ordreTransport, context) {
  //getIconFromCss('far custom-class fa-abacus');
  return Material(
    type: MaterialType.canvas,
    color: Colors.white,
    elevation: 1.0,
    child: Container(
      padding: const EdgeInsets.all(5.0),
      child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          columnWidths: const {
            0: FixedColumnWidth(30),
            1: FlexColumnWidth(1)
          },
          children: [
            TableRow(
              children: [
                SizedBox(
                  width: 30.0,
                  height: 90.0,
                  child: getSuiviInfos(ordreTransport['status'], 10.0),
                ),
                ListTile(
                  title: Table(
                    children: [
                      TableRow(children: [
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: iconBlock(
                            Icons.view_array,
                            ordreTransport['exp_initial_name'],
                            Colors.red,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: iconBlock(
                            Icons.view_array,
                            ordreTransport['dest_final_name'],
                            Colors.green,
                          ),
                        ),
                      ]),
                      TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: iconBlock(
                              Icons.calendar_month,
                              DateFormat('dd/MM/y HH:mm')
                                  .format(
                                    DateTime.parse(
                                        ordreTransport['date_enlevement']),
                                  )
                                  .replaceAll(' 00:00', ''),
                              Colors.red,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: iconBlock(
                              Icons.calendar_month,
                              DateFormat('dd/MM/y HH:mm')
                                  .format(
                                    DateTime.parse(
                                        ordreTransport['date_livraison']),
                                  )
                                  .replaceAll(' 00:00', ''),
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Table(
                    children: [
                      TableRow(children: [
                        Text(ordreTransport['num_ot']),
                      ]),
                    ],
                  ),
                  onTap: () => {
                    Navigator.pushNamed(
                      context,
                      '/ordre',
                      arguments: OrdreTransportParams(
                        ordreTransport['ordretransport_id'],
                      ),
                    ),
                  },
                )
              ],
            ),
          ]),
    ),
  );
}

Material getSuiviInfos(status, largeur) {
  if (status == null) {
    return const Material();
  }
  List datas = json.decode(status);

  List<Flexible> retour = [];
  for (final e in datas) {
    //
    List<Flexible> retourTrajet = [];
    for (final e2 in e) {
      retourTrajet.add(
        Flexible(
          child: Container(
            width: largeur,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: e2 == true
                      ? [
                          const Color.fromARGB(255, 120, 200, 120),
                          const Color.fromARGB(255, 150, 200, 150),
                        ]
                      : [
                          const Color.fromARGB(100, 150, 150, 150),
                          const Color.fromARGB(100, 170, 170, 170),
                        ]),
              //color: e2 == true ? Colors.green : Colors.black12,
              //border: Border.all(width: 0.5, color: Colors.white),
            ),
          ),
        ),
      );
    }
    retour.add(
      Flexible(
        child: Container(
          decoration: const BoxDecoration(
              //border: Border.all(color: Colors.white),
              ),
          child: Column(
            children: retourTrajet,
          ),
        ),
      ),
    );
  }

  return Material(child: Column(children: retour));
}
