import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vialticecmr/model/destot.dart';
import 'package:vialticecmr/model/ordretransport.dart';
import 'package:vialticecmr/screen/LoadingScreen.dart';
import 'package:vialticecmr/screen/SignatureDestotScreen.dart';
import 'package:vialticecmr/screen/TourneeScreen.dart';
import 'package:vialticecmr/screen/TrajetinfosScreen.dart';
import 'package:vialticecmr/screen/loadingCloneScreen.dart';
import 'package:vialticecmr/screen/pdfViewer.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/blocks.dart';
import 'package:vialticecmr/utils/localisation.dart' as localisation;

import '../utils/network.dart';

HandSignatureControl control = HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);
ValueNotifier<String?> svg = ValueNotifier<String?>(null);
ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);
ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

class OrdreTransportParams {
  final int ordretransportId;

  OrdreTransportParams(this.ordretransportId);
}

class TrajetScreen extends StatefulWidget {
  final DestOt destot;
  final OrdreTransport ordretransport;
  const TrajetScreen(
      {Key? key, required this.destot, required this.ordretransport})
      : super(key: key);

  @override
  _TrajetScreenState createState() => _TrajetScreenState();
}

class _TrajetScreenState extends State<TrajetScreen> {
  String landscapePathPdf = '';
  @override
  void initState() {
    super.initState();
  }

  Future<void> _show(String type, DestOt destot, bool selectTime) async {
    //Initialisation de l'ehure par rapport à si elle est déjà remplie
    TimeOfDay initialTime = TimeOfDay.now();
    switch (type) {
      case 'enlArrivee':
        setState(() => enlArriveeLoading = true);
        if (destot.getEnlArrivee != '0000-00-00 00:00:00') {
          initialTime =
              TimeOfDay.fromDateTime(DateTime.parse(destot.getEnlArrivee));
        }
        break;
      case 'enlDepart':
        setState(() => enlDepartLoading = true);
        if (destot.getEnlDepart != '0000-00-00 00:00:00') {
          initialTime =
              TimeOfDay.fromDateTime(DateTime.parse(destot.getEnlDepart));
        }
        break;
      case 'livArrivee':
        setState(() => livArriveeLoading = true);
        if (destot.getLivArrivee != '0000-00-00 00:00:00') {
          initialTime =
              TimeOfDay.fromDateTime(DateTime.parse(destot.getLivArrivee));
        }
        break;
      case 'livDepart':
        setState(() => livDepartLoading = true);
        if (destot.getLivDepart != '0000-00-00 00:00:00') {
          initialTime =
              TimeOfDay.fromDateTime(DateTime.parse(destot.getLivDepart));
        }
        break;
    }
    //Détermination de l'heure
    //sur simple clic on prend l'heure du téléphone
    //sur clic long on affiche le formulaire
    TimeOfDay? result = TimeOfDay.now();
    if (selectTime) {
      result = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          );
        },
      );
    } else {
      result = TimeOfDay.now();
    }

    if (result != null) {
      Position position = await localisation.getPosition();
      setState(() {
        //Construction de la date complete avec l'heure sélectionnée
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        String selectedTime =
            '$formattedDate ${result?.hour.toString().padLeft(2, '0')}:${result?.minute.toString().padLeft(2, '0')}:00';
        //Affectation selon le type
        switch (type) {
          case 'enlArrivee':
            destot.enlArrivee = selectedTime;
            destot.enlArriveeLatitude = position.latitude.toString();
            destot.enlArriveeLongitude = position.longitude.toString();
            break;
          case 'enlDepart':
            destot.enlDepart = selectedTime;
            destot.enlDepartLatitude = position.latitude.toString();
            destot.enlDepartLongitude = position.longitude.toString();
            break;
          case 'livArrivee':
            destot.livArrivee = selectedTime;
            destot.livArriveeLatitude = position.latitude.toString();
            destot.livArriveeLongitude = position.longitude.toString();
            break;
          case 'livDepart':
            destot.livDepart = selectedTime;
            destot.livDepartLatitude = position.latitude.toString();
            destot.livDepartLongitude = position.longitude.toString();
            break;
        }
        switch (type) {
          case 'enlDepart':
          case 'livDepart':
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: SignatureDestotScreen(
                      destot: widget.destot,
                      type: type,
                    )));

            break;
        }

        destot.setItem(destot);
        var ordre = OrdreTransport(ordretransportId: 0);
        ordre.updateStatus(destot.getOrdretransportId);
        ordre.touch(destot.getOrdretransportId);
        switch (type) {
          case 'enlArrivee':
            setState(() => enlArrivee = false);
            setState(() => enlArriveeLoading = false);
            break;
          case 'enlDepart':
            setState(() => enlDepart = false);
            setState(() => enlDepartLoading = false);
            break;
          case 'livArrivee':
            setState(() => livArrivee = false);
            setState(() => livArriveeLoading = false);
            break;
          case 'livDepart':
            setState(() => livDepart = false);
            setState(() => livDepartLoading = false);
            break;
        }
      });
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: Loadingcreen(message: 'Enregistrement...'),
        ),
      );
      await Network().synchronise();
      Navigator.pop(context);
    }
  }

  bool enlArrivee = true;
  bool enlArriveeLoading = false;
  bool enlDepart = true;
  bool enlDepartLoading = false;
  bool livArrivee = true;
  bool livArriveeLoading = false;
  bool livDepart = true;
  bool livDepartLoading = false;
  var myVariables = MyVariables();
  @override
  Widget build(BuildContext context) {
    enlArrivee = widget.destot.getEnlArrivee == '0000-00-00 00:00:00';
    enlDepart =
        !enlArrivee && widget.destot.getEnlDepart == '0000-00-00 00:00:00';
    livArrivee = !enlArrivee &&
        !enlDepart &&
        widget.destot.getLivArrivee == '0000-00-00 00:00:00';
    livDepart = !enlArrivee &&
        !enlDepart &&
        !livArrivee &&
        widget.destot.getLivDepart == '0000-00-00 00:00:00';
    List<String> pictures0 = [];
    void versScan() async {
      List<String> pictures;
      try {
        pictures = await CunningDocumentScanner.getPictures() ?? [];
        if (!mounted) return;
        setState(() {
          pictures0 = pictures;

          if (pictures0.length != 0) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: Loadingcreen(message: 'Envoi...'),
              ),
            );
            for (var element in pictures0) {
              Network()
                  .sendCmr(element, widget.destot.getDestotId,
                      widget.destot.getOrdretransportId)
                  .then((value) => Navigator.pop(context));
            }
          }

          //Navigator.pop(context);
        });
      } catch (exception) {
        // Handle exception here
      }
    }

    List<TableRow> blocImmat = [];
    if (widget.ordretransport.getTracteurImmat != '') {
      blocImmat.add(TableRow(
        children: [
          const Text('Tracteur'),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/plaque.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(widget.ordretransport.getTracteurImmat,
                style: const TextStyle(fontSize: 20)),
          ),
        ],
      ));
    }
    if (widget.ordretransport.getRemorqueImmat != '') {
      blocImmat.add(TableRow(
        children: [
          const Text('Remorque'),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/plaque.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(widget.ordretransport.getRemorqueImmat,
                style: const TextStyle(fontSize: 20)),
          ),
        ],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 10,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (widget.ordretransport.getCommentaire != ''
                    ? Container(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            const Text('Commentaire admin: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              widget.ordretransport.getCommentaire,
                              //overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            )
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 0.0,
                      )),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'ORDRE DE TRANSPORT - ${widget.ordretransport.getNumOt}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Text(
                              'Référence commande: ${widget.ordretransport.getRefCom}'),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: blocImmat,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      TextButton(
                        child: const Text("Afficher la Lettre de voiture"),
                        onPressed: () {
                          if (landscapePathPdf == '') {
                            Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: Loadingcreen(message: 'Génération...'),
                                ));
                            createFileOfPdfUrl(
                                    '${myVariables.getMyObject.getBaseUrl}Appliecmr/genLDV/?destot_id=${widget.destot.getDestotId}')
                                .then((f) {
                              Navigator.pop(context);
                              landscapePathPdf = f;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PDFScreen(path: landscapePathPdf),
                                ),
                              );
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PDFScreen(path: landscapePathPdf),
                              ),
                            );
                          }
                        },
                      ),
                      Row(
                        children: [
                          Text(widget.destot.getDestotName),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              'Marchandises: ${widget.destot.getQuantite} ${widget.destot.getEmballageName}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('${widget.destot.getMetre} mètres linéaires'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Text(
                        'CHARGEMENT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.view_array),
                              Text(widget.destot.getEnlLastname),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              Text('Le ${DateFormat('dd/MM/y HH:mm').format(
                                    DateTime.parse(
                                        widget.destot.getDateEnlevement),
                                  ).replaceAll(' 00:00', '')}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.place),
                              Flexible(
                                child: Text(
                                  '${widget.destot.getEnlAddress} ${widget.destot.getEnlZipcode} ${widget.destot.getEnlCity}',
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  getTrajetsButtons(
                                    widget.destot,
                                    enlArrivee,
                                    enlArriveeLoading,
                                    'enlArrivee',
                                    'Arrivée',
                                    widget.destot.getEnlArrivee,
                                  ),
                                  getTrajetsButtons(
                                    widget.destot,
                                    enlDepart,
                                    enlDepartLoading,
                                    'enlDepart',
                                    'Départ (chargé)',
                                    widget.destot.getEnlDepart,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Text('LIVRAISON',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                      Column(
                        children: [
                          Row(children: [
                            const Icon(Icons.view_array),
                            Text(widget.destot.getLivLastname),
                          ]),
                          Row(children: [
                            const Icon(Icons.calendar_month),
                            Text('Le ${DateFormat('dd/MM/y HH:mm').format(
                                  DateTime.parse(
                                      widget.destot.getDateLivraison),
                                ).replaceAll(' 00:00', '')}'),
                          ]),
                          Row(children: [
                            const Icon(Icons.place),
                            Flexible(
                              child: Text(
                                '${widget.destot.getLivAddress} ${widget.destot.getLivZipcode} ${widget.destot.getLivCity}',
                                softWrap: true,
                              ),
                            ),
                          ]),
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  getTrajetsButtons(
                                    widget.destot,
                                    livArrivee,
                                    livArriveeLoading,
                                    'livArrivee',
                                    'Arrivée',
                                    widget.destot.getLivArrivee,
                                  ),
                                  getTrajetsButtons(
                                    widget.destot,
                                    livDepart,
                                    livDepartLoading,
                                    'livDepart',
                                    'Départ (chargé)',
                                    widget.destot.getLivArrivee,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Table(
          children: [
            TableRow(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12.0),
                  ),
                  onPressed: () => {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: TrajetInfosScreen(
                              destot: widget.destot,
                            ))),
                  },
                  child: const Text(
                    'Autres informations',
                    textAlign: TextAlign.center,
                  ),
                ),
                //SizedBox(height: 0.1, width: 1),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12.0),
                    ),
                    onPressed: versScan,
                    child: const Text(
                      "Scanner un document",
                      textAlign: TextAlign.center,
                    )),
                for (var picture in pictures0) Image.file(File(picture)),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget getTrajetsButtons(destot, varView, varLoading, field, label, valeur) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.5),
      child: varLoading
          ? ElevatedButton(
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, elevation: 0.0),
              child: const SizedBox(
                height: 30.0,
                child: CircularProgressIndicator(),
              ))
          : varView
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20.0),
                  ),
                  onLongPress: () => {_show(field, destot, true)},
                  onPressed: () => {_show(field, destot, false)},
                  child: Text(textAlign: TextAlign.center, 'Signaler\n$label'))
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20.0),
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onLongPress: () => {_show(field, destot, true)},
                  onPressed: () => {},
                  child: Text(
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                      '$label \n${DateFormat('HH:mm').format(
                        DateTime.parse(valeur),
                      )}'),
                ),
    );
  }
}

class OrdreTransportScreen extends StatefulWidget {
  final OrdreTransport ordretransport;

  const OrdreTransportScreen({Key? key, required this.ordretransport})
      : super(key: key);

  @override
  _OrdreTransportScreenState createState() => _OrdreTransportScreenState();
}

class _OrdreTransportScreenState extends State<OrdreTransportScreen> {
  String landscapePathPdf = '';
  String res_clonage = '';
  @override
  void initState() {
    super.initState();
  }

  onPressClone(int getDestotId) {
    Network().cloneTrajet(destot_id: getDestotId);
  }

  @override
  Widget build(BuildContext context) {
    var myVariables = MyVariables();
    //context.widget.noSuchMethod(invocation)
    myVariables.setCurrentContext(context);
    //Construction des onglets
    List<Tab> myTabs = [];
    for (var i = 0; i < widget.ordretransport.getNbDests; i++) {
      //récupération de la possibilité de cloner

      if (widget.ordretransport.destots[i].getIsClonable) {
        myTabs.add(Tab(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text('TR#${i + 1}'),
              IconButton(
                  onPressed: () => {
                        Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: LoadingCloneScreen(
                                  destot_id: widget
                                      .ordretransport.destots[i].getDestotId,
                                  ordretransport_id: widget
                                      .ordretransport.getOrdretransportId),
                            )),
                      },
                  icon: Icon(Icons.add_box))
            ])));
      } else {
        myTabs.add(Tab(text: 'TR#${i + 1}'));
      }
      //myTabs.add(Tab(text: 'TR#${i + 1}'));
    }

    myTabs.add(const Tab(text: 'Infos OT'));

    //Construction du contenu des onglets
    List<Widget> onglets = <Widget>[];
    for (var i = 0; i < widget.ordretransport.getNbDests; i++) {
      onglets.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  flex: 1,
                  child: TrajetScreen(
                    destot: widget.ordretransport.destots[i],
                    ordretransport: widget.ordretransport,
                  )),
            ]),
      ));
    }
    onglets.add(
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(5.0),
          child: Column(children: [
            Text(
              'Donneur d\'ordre',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(widget.ordretransport.getDonneurordreName),
            Text(widget.ordretransport.getDonneurordreAddress),
            Text(
                '${widget.ordretransport.getDonneurordreZipcode} ${widget.ordretransport.getDonneurordreCity}'),
            widget.ordretransport.getExpInitialName != 'null'
                ? Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FixedColumnWidth(5),
                      2: FlexColumnWidth(1)
                    },
                    children: [
                      TableRow(children: [
                        Column(children: [
                          Text('Expéditeur initial',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          Text(widget.ordretransport.getExpInitialName,
                              style: myVariables.styles['style_p']),
                          Text(widget.ordretransport.getExpInitialAddress),
                          Text(
                              '${widget.ordretransport.getExpInitialZipcode} ${widget.ordretransport.getExpInitialCity}'),
                        ]),
                        const SizedBox(
                            width: 10.0, child: Icon(Icons.arrow_forward)),
                        Column(children: [
                          Text('Destinataire final',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          Text(widget.ordretransport.getDestFinalName),
                          Text(widget.ordretransport.getDestFinalAddress),
                          Text(
                              '${widget.ordretransport.getDestFinalZipcode} ${widget.ordretransport.getDestFinalCity}'),
                        ]),
                      ]),
                    ],
                  )
                : const Text(''),
          ]),
        ),
      ),
    );
    print(widget.ordretransport.getTourneeId);
    //Construction du widget contenu
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              if (widget.ordretransport.getTourneeId == 0) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', ModalRoute.withName('/'));
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TourneeLandingScreen(
                        tourneeId: widget.ordretransport.getTourneeId),
                  ),
                  ModalRoute.withName('/tournee'),
                );
              }
            },
          ),
          title: widget.ordretransport.getTourneeId == 0
              ? const Text('retour à la liste')
              : const Text('retour à la tournée'),
          bottom: TabBar(
            isScrollable: true,
            padding: EdgeInsets.all(1),
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: onglets,
        ),
        persistentFooterButtons: piedpageconnected(context),
      ),
    );
  }
}
