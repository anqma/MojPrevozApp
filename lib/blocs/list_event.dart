import 'package:moj_prevoz/model/list_prevoz.dart';

abstract class ListEvent {}

class ListInitializedEvent extends ListEvent {}

class ListElementAddedEvent extends ListEvent {
  final ListPrevoz element;
  ListElementAddedEvent({required this.element});
}

class ListElementDeletedEvent extends ListEvent {
  final String id;
  ListElementDeletedEvent({required this.id});
}
