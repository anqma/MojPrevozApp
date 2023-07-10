import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moj_prevoz/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Model/list_prevoz.dart';

class ListDetailScreen extends StatelessWidget {
  static const routeName = '/list_detail';

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as ListPrevoz;
    return Scaffold(
        appBar: AppBar(
          title: Text("${item.pocetnaDest} > ${item.krajnaDest}"),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          backgroundColor: myColorLight,
          foregroundColor: Colors.white,
        ),
        body: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.calendarDays,
                        color: Colors.blueGrey,
                        size: 25,
                      ),
                      SizedBox(height: 7),
                      FaIcon(
                        FontAwesomeIcons.userGroup,
                        color: Colors.blue,
                        size: 25,
                      ),
                      SizedBox(height: 7),
                      FaIcon(
                        FontAwesomeIcons.moneyBill1,
                        color: Colors.amber,
                        size: 25,
                      ),
                      SizedBox(height: 7),
                      FaIcon(
                        FontAwesomeIcons.car,
                        color: Colors.red,
                        size: 25,
                      ),
                      SizedBox(height: 7),
                      FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "На ${item.datumIcas.toString().substring(8, 10)}/${item.datumIcas.toString().substring(5, 7)}/${item.datumIcas.toString().substring(0, 4)} во ${item.datumIcas.toString().substring(11, 16)}h",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Има ${item.slobodniMesta} слободни места.",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${item.cena} денари",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${item.vozilo}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${item.telBroj}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ])
                ]),
              ],
            ),
          ),
        ));
  }
}
