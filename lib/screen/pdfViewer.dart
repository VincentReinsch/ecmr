import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vialticecmr/utils/MyVariables.dart';

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({Key? key, this.path}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

Future<File> fromAsset(String asset, String filename) async {
  // To open from assets, you can copy them to the app storage folder, and the access them "locally"
  Completer<File> completer = Completer();

  try {
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");
    var data = await rootBundle.load(asset);
    var bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }

  return completer.future;
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lettre de voiture"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (pages) {
              setState(() {
                pages = pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {},
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                ),
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}

Future<String> createFileOfPdfUrl(String url) async {
  Completer<File> completer = Completer();
  var myVariables = MyVariables();
  String fichier = '';
  try {
    var request1 = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: <String, String>{
      'user_login': myVariables.getMyObject.getLogin,
      'user_password': myVariables.getMyObject.getPassword,
      'tiers_id': myVariables.getMyObject.getTiersId.toString(),
    });

    var jsonResponse = json.decode(request1.body);

    url = jsonResponse['success'];

    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();

    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    final filename =
        jsonResponse['success'].substring(url.lastIndexOf("/") + 1);
    File file = File("${dir.path}/$filename");

    fichier = "${dir.path}/$filename";

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {}

  return fichier;
}
