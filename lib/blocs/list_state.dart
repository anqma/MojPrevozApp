import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moj_prevoz/Model/list_prevoz.dart';

abstract class ListState {}

class ListInitState extends ListElementsState {
  ListInitState()
      : super(elements: [
          ListPrevoz(
            id: '1',
            pocetnaDest: "Skopje",
            krajnaDest: "Maribot",
            datumIcas: DateTime(2017, 9, 7, 17, 30),
            slobodniMesta: "3",
            cena: "300",
            vozilo: "audi",
            telBroj: "0788888999",
            userId: "123",
            mesto: const GeoPoint(41.9965, 21.4314),
          ),
          ListPrevoz(
            id: '2',
            pocetnaDest: "Skopje",
            krajnaDest: "Ljubljana",
            datumIcas: DateTime(2052, 8, 7, 17, 30),
            slobodniMesta: "1",
            cena: "400",
            vozilo: "bmw",
            telBroj: "078789654",
            userId: "23",
            mesto: const GeoPoint(41.9965, 21.4314),
          ),
        ]) {
    this.elements = [];
  }
}

class ListEmptyState extends ListState {}

class ListElementsState extends ListState {
  List<ListPrevoz> elements;
  ListElementsState({required this.elements});
}

class ListError extends ListState {
  final error;
  ListError({this.error});
}
