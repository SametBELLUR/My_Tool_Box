import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_tool_box/databases/HesDB.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_tool_box/models/HesCodeModel.dart';
import 'package:my_tool_box/databases/HesDB.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<HesCodeModel> hesses = [];
StreamController<List<HesCodeModel>> streamController =
    StreamController.broadcast();
TextEditingController HesInputController = TextEditingController();
bool hesLoaded = false;

void getHes() async {
  Future<List<HesCodeModel>> temp = HesDB.instance.getHesCode();
  hesses = await temp;
  hesLoaded = isLoaded(await temp);

  streamController.add(hesses);
}

bool isLoaded(List<HesCodeModel> temp) {
  return true;
}

class Hes extends StatefulWidget {
  _hesState createState() => _hesState();
}

class _hesState extends State<Hes> {
  int selectedIndex = 0;

  void initState() {
    super.initState();
    getHes();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              AppLocalizations.of(context)!.ur_hes_code,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: StreamBuilder<List<HesCodeModel>>(
                    stream: streamController.stream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          debugPrint("waiting");
                          return Center(child: CircularProgressIndicator());
                          break;
                        case ConnectionState.none:
                          debugPrint("none");
                          return Center(child: CircularProgressIndicator());
                          break;
                        case ConnectionState.active:
                        case ConnectionState.done:
                          return Scaffold(
                            body: Builder(builder: (context) {
                              return Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      QrImage(
                                        data: hesses[0].hes,
                                        size: 200,
                                        foregroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Center(
                                          child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          hesses[0].hes,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 42.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      )),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) => HesForm(),
                                          );
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .hes_code_add_edit),
                                      ),
                                    ]),
                              );
                            }),
                          );
                          break;
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Create a Form widget.
class HesForm extends StatefulWidget {
  const HesForm({Key? key}) : super(key: key);

  @override
  HesFormState createState() {
    return HesFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class HesFormState extends State<HesForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
        padding: mediaQueryData.viewInsets,
        child: Wrap(children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(40),
                    child: TextFormField(
                      controller: HesInputController,
                      decoration: new InputDecoration(
                        hintText: hesses[0].hes,
                        labelText: AppLocalizations.of(context)!.hes_code,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return (AppLocalizations.of(context)!.enter_txt);
                        }
                        return null;
                      },
                    )),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      if (hesses[0].hes == "-") {
                        HesDB.instance.create(HesInputController.text);
                        getHes();
                      } else {
                        debugPrint(hesses.length.toString());
                        debugPrint(hesses[0].id.toString());
                        debugPrint(hesses[0].hes);
                        HesDB.instance
                            .updateHes(hesses[0].id, HesInputController.text);
                        getHes();
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.submit),
                ),
              ],
            ),
          )
        ]));
  }
}
