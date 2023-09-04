import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hand_signature/signature.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/blocks.dart';
import 'package:vialticecmr/utils/scrollTest.dart';
import 'package:vialticecmr/utils/network.dart';
import 'package:vialticecmr/utils/signature.dart' as signature;
import 'package:path_provider/path_provider.dart';

HandSignatureControl control = HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);
ValueNotifier<String?> svg = ValueNotifier<String?>(null);
ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);
ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  bool get scrollTest => false;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    var myVariables = MyVariables();
    myVariables.setCurrentContext(context);
    return Scaffold(
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
      body: scrollTest
          ? const ScrollTest()
          : SafeArea(
              child: Column(children: [
                Table(children: [
                  TableRow(children: [
                    const Text('Nom'),
                    Text(myVariables.getMyObject.getLastName),
                    const Text('Prénom'),
                    Text(myVariables.getMyObject.getFirstName)
                  ]),
                ]),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            constraints: const BoxConstraints.expand(),
                            color: Colors.white,
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
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('Effacer'),
                      onPressed: () {
                        control.clear();
                        svg.value = null;
                        rawImage.value = null;
                        rawImageFit.value = null;
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                      child: const Text('Enregistrer'),
                      onPressed: () async {
                        setState(() => _loading = true);
                        await signature.enregistreSignature(
                            svg,
                            control,
                            rawImage,
                            rawImageFit,
                            'signature_${myVariables.getMyObject.getTiersId}.png');

                        Directory tempDir =
                            await getApplicationDocumentsDirectory();
                        String tempPath = tempDir.path;

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: const Text("Title"),
                              content: Image.file(
                                File(
                                    '$tempPath/signature_${myVariables.getMyObject.getTiersId}.png'),
                              ),
                            );
                          },
                        );
                        Network().setUserSignature(
                            '$tempPath/signature_${myVariables.getMyObject.getTiersId}.png',
                            'signature',
                            'tiers',
                            myVariables.getMyObject.getTiersId.toString(),
                            '');
                      },
                    )
                  ],
                )
              ]),
            ),
      persistentFooterButtons: piedpageconnected(context),
    );
  }
}

Future<File> writeToFile(ByteData? data, String path) async {
  final buffer = data!.buffer;
  Directory tempDir = await getApplicationDocumentsDirectory();
  String tempPath = tempDir.path;

  return File('$tempPath/$path')
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
