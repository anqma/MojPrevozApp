import 'package:flutter/material.dart';
import 'package:moj_prevoz/Model/list_prevoz.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home/list_detail_screen.dart';

class MyListTile extends StatelessWidget {
  final ListPrevoz item;
  final Function func;

  void _showDetail(BuildContext context) {
    Navigator.of(context).pushNamed(
      ListDetailScreen.routeName,
      arguments: item,
    );
  }

  MyListTile(this.item, this.func);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      child: ListTile(
        title: Text(
          "${item.pocetnaDest} > ${item.krajnaDest}",
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        subtitle: Column(
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
                    size: 20,
                  ),
                  SizedBox(height: 4),
                  FaIcon(
                    FontAwesomeIcons.moneyBill1,
                    color: Colors.amber,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "${item.datumIcas.toString().substring(8, 10)}/${item.datumIcas.toString().substring(5, 7)}/${item.datumIcas.toString().substring(0, 4)} во ${item.datumIcas.toString().substring(11, 16)}h",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.cena} денари",
                  style: const TextStyle(fontSize: 14),
                )
              ])
            ]),
          ],
        ),
        onTap: () => _showDetail(context),
      ),
    );
  }
}
