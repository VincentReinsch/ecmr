import 'package:flutter/material.dart';
import 'package:vialticecmr/model/destot.dart';
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
      fields.add(
        Form(
          child: element.getType == 'text' || element.getType == 'numeric'
              ? TextFormField(
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
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                )
              : element.getType == 'title'
                  ? Row(children: [
                      Text(element.getName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ])
                  : Row(
                      children: [
                        SizedBox(
                          width: element.getParent != 'null' ? 10.0 : 0,
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          value: element.getValue == '1',
                          onChanged: (bool? value) {
                            setState(() {
                              element.setValue =
                                  element.getValue == '1' ? '0' : '1';
                            });
                          },
                        ),
                        Text(element.getName),
                      ],
                    ),
        ),
      );
      fields.add(const SizedBox(
        height: 10.0,
      ));
    }
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
              widget.destot.setAdditionnalFields(destOtAdditionnalFields),
              widget.destot.setItem(widget.destot),
              await Network().synchronise(),
              Navigator.pop(context),
            },
            child: const Text(
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
