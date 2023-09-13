import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vialticecmr/model/destot.dart';
import 'package:vialticecmr/screen/LoadingScreen.dart';
import 'package:vialticecmr/utils/blocks.dart';
import 'package:vialticecmr/utils/network.dart';

class TrajetInfosScreen extends StatefulWidget {
  final DestOt destot;

  const TrajetInfosScreen({Key? key, required this.destot}) : super(key: key);

  @override
  _TrajetInfosScreenState createState() => _TrajetInfosScreenState();
}

class _TrajetInfosScreenState extends State<TrajetInfosScreen> {
  //DestOt _destOt = DestOt(destotId:this.destotid);
  //final _destOt = widget.destot;

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [];
    final List<DestOtAdditionnalField> datas =
        widget.destot.getAdditionnalFields;

    var destOtAdditionnalFields = datas;
    fields.add(const Text(
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        'Infomations supplémentaires'));
    for (var element in destOtAdditionnalFields) {
      if (element.getType == 'text' || element.getType == 'numeric') {
        fields.add(
          DefaultTextStyle(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
            child: Text(element.getName),
          ),
        );
        fields.add(const SizedBox(
          height: 2.0,
        ));
      }
      Widget content = Text('');

      switch (element.getType) {
        case 'text':
        case 'numeric':
          content = TextFormField(
            keyboardType: element.getType == 'numeric'
                ? TextInputType.number
                : TextInputType.text,
            initialValue: element.getValue,
            onChanged: (value) => setState(
              () => element.setValue = value,
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Veuillez saisir une valeur'
                : null,
            decoration: const InputDecoration(
              hintText: '',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            ),
          );
          break;
        case 'title':
          content = Row(children: [
            Text(element.getName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]);
          break;
        case 'yesno':
          content = Row(
            children: [
              SizedBox(
                width: element.getParent != 'null' ? 10.0 : 0,
              ),
              Checkbox(
                checkColor: Colors.white,
                value: element.getValue == '1',
                onChanged: (bool? value) {
                  setState(() {
                    element.setValue = element.getValue == '1' ? '0' : '1';
                  });
                },
              ),
              Text(element.getName),
            ],
          );
          break;
        case 'datetime':
          if (element.getValue == '') {
            content = ElevatedButton(
              onPressed: () => {
                setState(() {
                  element.setValue = DateTime.now().toString();
                })
              },
              child: Text(element.getName),
            );
          } else {
            content = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    element.getName +
                        ': ' +
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(DateTime.parse(element.getValue)),
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      setState(() {
                        element.setValue = '';
                      })
                    },
                    child: Icon(Icons.close),
                  ),
                ]);
          }
          break;
        case 'select':
          List<DropdownMenuItem<String>> items =
              getItemListFormTxt(element.getParams);

          content =
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(element.getName),
            DropdownButton<String>(
              value: element.getValue,
              items: items,
              onChanged: (String? value) {
                setState(() {
                  element.setValue = value!;
                });
              },
            )
          ]);
          break;
      }
      fields.add(
        Form(child: content),
      );
      fields.add(const SizedBox(
        height: 10.0,
      ));
    }
    bool saving = false;
    fields.add(
      Table(children: [
        TableRow(children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20.0),
            ),
            onPressed: () => {
              Navigator.pop(context),
            },
            child: const Text(
              'Annuler',
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20.0),
            ),
            onPressed: () async => {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: Loadingcreen(),
                ),
              ),
              widget.destot.setAdditionnalFields(destOtAdditionnalFields),
              widget.destot.setItem(widget.destot),
              await Network().synchronise(),
              Navigator.pop(context),
              Navigator.pop(context),
            },
            child: Text(
              'Enregistrer',
              textAlign: TextAlign.center,
            ),
          ),
        ])
      ]),
    );

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
                children: fields,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
