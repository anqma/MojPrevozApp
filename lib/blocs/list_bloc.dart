import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../Model/list_prevoz.dart";
import "list_event.dart";
import "list_state.dart";

class ListBloc extends Bloc<ListEvent, ListState> {
  late List<ListPrevoz> _elements;

  ListBloc() : super(ListInitState()) {
    on<ListInitializedEvent>((event, emit) {
      _elements = [
        ListPrevoz(
          id: '1',
          pocetnaDest: "Скопје",
          krajnaDest: "Дебар",
          datumIcas: DateTime(2017, 9, 7, 17, 30),
          slobodniMesta: "3",
          cena: "300",
          vozilo: "audi",
          telBroj: "078800200",
          userId: "123",
          mesto: const GeoPoint(41.9965, 21.4314),
        ),
        ListPrevoz(
          id: '2',
          pocetnaDest: "Скопје",
          krajnaDest: "Охрид",
          datumIcas: DateTime(2052, 8, 7, 17, 30),
          slobodniMesta: "1",
          cena: "400",
          vozilo: "bmw",
          telBroj: "078986598",
          userId: "23",
          mesto: const GeoPoint(41.9965, 21.4314),
        ),
      ];
      ListInitState state = ListInitState();
      state.elements = _elements;
      emit(state);
    });
    on<ListElementAddedEvent>((event, emit) {
      _elements.add(event.element as ListPrevoz);
      emit(ListElementsState(elements: _elements));
    });
    on<ListElementDeletedEvent>((event, emit) {
      _elements.removeWhere((p) => p.id == event.id);
      if (_elements.length > 0) {
        emit(ListElementsState(elements: _elements));
      } else {
        emit(ListEmptyState());
      }
    });
  }
}
