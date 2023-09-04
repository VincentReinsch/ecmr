import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hand_signature/signature.dart';
import 'package:vialticecmr/utils/MyVariables.dart';

Future<bool> enregistreSignature(svg, HandSignatureControl control, rawImage,
    rawImageFit, nomFichier) async {
  svg.value = control.toSvg(
    color: Colors.blueGrey,
    width: 512,
    height: 512,
    strokeWidth: 2.0,
    maxStrokeWidth: 15.0,
    type: SignatureDrawType.shape,
  );
  var myvariable = MyVariables();
  rawImage.value = await control.toImage(
    width: 512,
    height: 512,
    color: Colors.blueAccent,
    background: Colors.greenAccent,
    fit: false,
  );
  rawImageFit.value = await control.toImage(
    width: 512,
    height: 512,
    color: Colors.black,
    background: const Color.fromARGB(0, 255, 255, 255),
  );

  if (rawImageFit.value != null) {
    writeToFile(rawImageFit.value, nomFichier);
    return true;
  }
  return false;
}

Future<File> writeToFile(ByteData? data, String path) async {
  final buffer = data!.buffer;
  Directory tempDir = await getApplicationDocumentsDirectory();
  String tempPath = tempDir.path;

  return File('$tempPath/$path')
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
