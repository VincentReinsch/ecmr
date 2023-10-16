import 'package:flutter/material.dart';

class Loadingcreen extends StatefulWidget {
  const Loadingcreen({Key? key, required this.message}) : super(key: key);
  final String message;
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<Loadingcreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text(widget.message),
                  ),
                  SizedBox(height: 50),
                  Center(
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
