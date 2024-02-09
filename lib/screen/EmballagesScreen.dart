import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vialticecmr/model/destot.dart';
import 'package:vialticecmr/screen/LoadingScreen.dart';
import 'package:vialticecmr/utils/network.dart';

class EmballagesScreen extends StatefulWidget {
  final DestOt destot;

  const EmballagesScreen({Key? key, required this.destot}) : super(key: key);

  @override
  _EmballagesScreenState createState() => _EmballagesScreenState();
}

class _EmballagesScreenState extends State<EmballagesScreen> {
  //DestOt _destOt = DestOt(destotId:this.destotid);
  //final _destOt = widget.destot;

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [];
    final List<Emballage> datas = widget.destot.getEmballages;
    print(datas);
    var emballagesFields = datas;
    fields.add(const Text(
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        'Modifier les quantités'));
    for (var element in datas) {
      fields.add(Row(children: [
        ConstrainedBox(
          constraints: BoxConstraints.tight(const Size(50, 50)),
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: element.getQuantite,
            onChanged: (value) => setState(
              () => element.quantite = value,
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
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        DefaultTextStyle(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15.0,
          ),
          child: Text(element.getEmballageName),
        ),
      ]));

      Widget content = Text('');

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
                  child: Loadingcreen(message: 'Enregistrement...'),
                ),
              ),
              // widget.destot.setAdditionnalFields(destOtAdditionnalFields),
              widget.destot.setEmballages(emballagesFields),
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
