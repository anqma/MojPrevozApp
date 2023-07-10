import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moj_prevoz/dodadi_prevoz.dart';
import 'package:moj_prevoz/home/prebaraj_prevoz.dart';
import 'package:moj_prevoz/main.dart';

import '../Model/list_prevoz.dart';
import '../blocs/list_bloc.dart';
import '../blocs/list_event.dart';
import '../widgets/my_list_tile.dart';

class PonudeniPrevozi extends StatefulWidget {
  const PonudeniPrevozi({Key? key});
  static const routeName = '/';

  @override
  State<PonudeniPrevozi> createState() => _PonudeniPrevoziState();
}

class _PonudeniPrevoziState extends State<PonudeniPrevozi> {
  void _deleteItem(BuildContext ctx, String id) {
    final bloc = BlocProvider.of<ListBloc>(ctx);
    bloc.add(ListElementDeletedEvent(id: id));
  }

  void _prebaraj(BuildContext ct) {
    Navigator.of(context).pushNamed(
      PrebarajPrevoz.routeName,
    );
  }

  Future<List<ListPrevoz>> readItems() => FirebaseFirestore.instance
      .collection('prevozi')
      .get()
      .then((response) => response.docs
          .map((element) => ListPrevoz.fromJson(element.data()))
          .toList());

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
      context: ct,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: DodadiPrevoz(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewItemToList(BuildContext ctx, item) {
    final bloc = BlocProvider.of<ListBloc>(ctx);
    bloc.add(ListElementAddedEvent(element: item));
  }

  Widget buildItem(ListPrevoz prevoz) {
    return MyListTile(
      prevoz,
      _deleteItem,
    );
  }

  Widget _createBody(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: FutureBuilder<List<ListPrevoz>>(
                future: readItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      "Error! ${snapshot.error.toString()}",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<ListPrevoz> prevozi = snapshot.data!;
                    if (prevozi.isEmpty) {
                      return Text(
                        "Нема додадено превози!",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: prevozi.length,
                      itemBuilder: (context, index) {
                        return buildItem(prevozi[index]);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Превози"),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        backgroundColor: myColorLight,
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              size: 30,
            ),
            onPressed: () => _prebaraj(context),
          ),
        ],
      ),
      body: _createBody(context),
    );
  }
}
