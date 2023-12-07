import 'medicament.dart';

class Ordonnance {
  int id;
  List<Medicament> medicament;

  Ordonnance({
    required this.id,
    required this.medicament,
  });
}