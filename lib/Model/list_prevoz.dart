import 'package:cloud_firestore/cloud_firestore.dart';

class ListPrevoz {
  final String id;
  final String pocetnaDest;
  final String krajnaDest;
  final DateTime datumIcas;
  final String slobodniMesta;
  final String cena;
  final String vozilo;
  final String telBroj;
  final String userId;
  final GeoPoint mesto;

  ListPrevoz(
      {this.id = '',
      required this.pocetnaDest,
      required this.krajnaDest,
      required this.datumIcas,
      required this.slobodniMesta,
      required this.cena,
      required this.vozilo,
      required this.telBroj,
      required this.userId,
      required this.mesto});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pocetnaDest': pocetnaDest,
      'krajnaDest': krajnaDest,
      'datumIcas': datumIcas,
      'slobodniMesta': slobodniMesta,
      'cena': cena,
      'vozilo': vozilo,
      'telBroj': telBroj,
      'userId': userId,
      'mesto': mesto,
    };
  }

  static ListPrevoz fromJson(Map<String, dynamic> json) => ListPrevoz(
        id: json['id'],
        pocetnaDest: json['pocetnaDest'],
        krajnaDest: json['krajnaDest'],
        datumIcas: (json['datumIcas'] as Timestamp).toDate(),
        slobodniMesta: json['slobodniMesta'],
        cena: json['cena'],
        vozilo: json['vozilo'],
        telBroj: json['telBroj'],
        userId: json['userId'],
        mesto: json['mesto'],
      );
}
