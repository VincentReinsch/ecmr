import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vialticecmr/model/destot.dart';
import 'package:vialticecmr/screen/LoadingScreen.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/network.dart';
import 'package:vialticecmr/utils/signature.dart' as signature;

HandSignatureControl control = HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);
ValueNotifier<String?> svg = ValueNotifier<String?>(null);
ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);
ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

class SignatureDestotScreen extends StatefulWidget {
  final DestOt destot;
  final String type;
  String signature_nom = '';
  String signature_reserves = '';
  String tempPath = MyVariables().getMyPath;

  SignatureDestotScreen({Key? key, required this.destot, required this.type})
      : super(key: key);

  @override
  _SignatureDestotScreenState createState() => _SignatureDestotScreenState();
}

class _SignatureDestotScreenState extends State<SignatureDestotScreen> {
  @override
  void initState() {
    super.initState();
    control.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    svg.value = null;
    rawImage.value = null;
    rawImageFit.value = null;

    switch (widget.type) {
      case 'enlDepart':
        widget.signature_nom = widget.destot.expSignatureNom;
        widget.signature_reserves = widget.destot.expReserves;
        break;
      case 'livDepart':
        widget.signature_nom = widget.destot.destSignatureNom;
        widget.signature_reserves = widget.destot.destReserves;
        break;
    }
  }

  getBlocSignature() {
    hasSignature = false;
    var fichier = File(chemin_signature);
    if (fichier.existsSync()) {
      hasSignature = true;
    }
    return hasSignature
        ? Image.file(File(chemin_signature))
        : Center(
            child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: <Widget>[
                Container(
                  constraints: const BoxConstraints.expand(),
                  color: Colors.grey,
                  child: HandSignature(
                    control: control,
                    type: SignatureDrawType.shape,
                  ),
                ),
                CustomPaint(
                  painter: DebugSignaturePainterCP(
                    control: control,
                    cp: false,
                    cpStart: false,
                    cpEnd: false,
                  ),
                ),
              ],
            ),
          ));
  }

  bool hasSignature = false;
  bool checkSignature = true;
  var chemin_signature = '';

  @override
  Widget build(BuildContext context) {
    chemin_signature = checkSignature
        ? '${widget.tempPath}/signature_${widget.destot.getDestotId}_${widget.type}.png'
        : '';
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
          title: const Text('Retour au trajet'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Material(
            borderOnForeground: true,
            child: Column(
              children: [
                Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(4),
                    },
                    children: [
                      TableRow(
                        children: [
                          const Text('Nom'),
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            initialValue: widget.signature_nom,
                            onChanged: (value) => {
                              setState(() => widget.signature_nom = value),
                              widget.destot.setItem(widget.destot)
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Veuillez saisir votre login'
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'Tapez le nom',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text('Réserves'),
                          TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            initialValue: widget.signature_reserves,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) => {
                              setState(() => widget.signature_reserves = value),
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Veuillez saisir Les réserves'
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'Tapez les réserves',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                    ]),
                const SizedBox(
                  height: 10.0,
                ),
                const Text('Signature'),
                getBlocSignature(),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('Effacer'),
                      onPressed: () {
                        setState(() {
                          checkSignature = false;
                          chemin_signature = '';
                        });

                        control.clear();
                        svg.value = null;
                        rawImage.value = null;
                        rawImageFit.value = null;
                      },
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    ElevatedButton(
                      child: const Text('Enregistrer'),
                      onPressed: () async {
                        switch (widget.type) {
                          case 'enlDepart':
                            widget.destot
                                .setExpSignatureNom(widget.signature_nom);
                            widget.destot
                                .setExpReserves(widget.signature_reserves);
                            break;
                          case 'livDepart':
                            widget.destot
                                .setDestSignatureNom(widget.signature_nom);
                            widget.destot
                                .setDestReserves(widget.signature_reserves);
                            break;
                        }
                        widget.destot.setItem(widget.destot);
                        if (await signature.enregistreSignature(
                            svg,
                            control,
                            rawImage,
                            rawImageFit,
                            'signature_${widget.destot.getDestotId}_${widget.type}.png')) {
                          Directory tempDir =
                              await getApplicationDocumentsDirectory();
                          String tempPath = tempDir.path;
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: Loadingcreen(
                                  message: 'Enregistrement signature...'),
                            ),
                          );
                          await Network().setUserSignature(
                            '$tempPath/signature_${widget.destot.getDestotId}_${widget.type}.png',
                            'signature_destot_${widget.type}',
                            'ordretransport',
                            widget.destot.getOrdretransportId.toString(),
                            widget.destot.getDestotId.toString(),
                          );
                          Navigator.pop(context);
                          //
                          switch (widget.type) {
                            case 'enlDepart':
                              widget.destot.setExpSignature('oui');

                              break;
                            case 'livDepart':
                              widget.destot.setDestSignature('oui');

                              break;
                          }
                          widget.destot.setItem(widget.destot);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
