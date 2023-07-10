import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moj_prevoz/dodadi_prevoz.dart';
import 'package:moj_prevoz/home/ponudeni_prevozi.dart';
import 'package:moj_prevoz/main.dart';

class PrebarajPrevoz extends StatefulWidget {
  const PrebarajPrevoz({super.key});
  static const routeName = '/prebaraj_prevoz';

  @override
  State<PrebarajPrevoz> createState() => _PrebarajPrevozState();
}

class _PrebarajPrevozState extends State<PrebarajPrevoz> {
  final _poagjanjeController = TextEditingController();
  final _pristignuvanjeController = TextEditingController();
  final _datumController = TextEditingController();

  DateTime pickedDate = DateTime.now();

  void _barajPrevoz(BuildContext context) {
    if (_datumController.text.isEmpty ||
        _poagjanjeController.text.isEmpty ||
        _pristignuvanjeController.text.isEmpty) {
      return;
    }

    final poagjanje = _poagjanjeController.text;
    final pristignuvanje = _pristignuvanjeController.text;
    final vnesenDatum = DateTime.parse(_datumController.text);

    Navigator.of(context).pushNamed(
      PonudeniPrevozi.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 40.0, bottom: 60.0),
                        child: SizedBox(
                            width: 350,
                            child: Text(
                              'Каде сакаш да одиш?',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: _poagjanjeController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Место на поаѓање',
                          hintText: 'Внеси место на поаѓање',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 30.0, left: 5.0, right: 5.0),
                      child: TextField(
                        controller: _pristignuvanjeController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Место на пристигнување',
                          hintText: 'Внеси место на пристигнување',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 30.0, left: 5.0, right: 5.0),
                      child: TextField(
                        controller: _datumController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Датум',
                          hintText: 'Внеси посакуван датум',
                        ),
                        readOnly: true,
                        onTap: () async {
                          pickedDate = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101)))!;
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _datumController.text = formattedDate;
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Material(
                          borderRadius: BorderRadius.circular(30.0),
                          //elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () => _barajPrevoz(context),
                            minWidth: 200,
                            height: 50.0,
                            color: myColor,
                            child: const Text(
                              "Пребарај",
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ))
                  ],
                ))));
  }
}
