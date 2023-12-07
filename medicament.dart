class Medicament {
  int? id;
  String nom;
  String posologie;
  String dateD;
  String seuil;
  double prix;
  String dateP;
  int stock;
  int? idOrd;
  int pilulesParPaquet; // Add this attribute

  Medicament({
    this.id,
    required this.nom,
    required this.posologie,
    required this.dateD,
    required this.seuil,
    required this.prix,
    required this.dateP,
    required this.stock,
    this.idOrd,
    required this.pilulesParPaquet, // Add this line
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'posologie': posologie,
      'dateD': dateD,
      'seuil': seuil,
      'prix': prix,
      'dateP': dateP,
      'stock': stock,
      'idOrd': idOrd,
      'pilulesParPaquet': pilulesParPaquet, // Add this line
    };
  }

  factory Medicament.fromMap(Map<String, dynamic> map) {
    return Medicament(
      id: map['id'],
      nom: map['nom'],
      posologie: map['posologie'],
      dateD: map['dateD'],
      seuil: map['seuil'],
      prix: map['prix'],
      dateP: map['dateP'],
      stock: map['stock'],
      idOrd: map['idOrd'],
      pilulesParPaquet: map['pilulesParPaquet'], // Add this line
    );
  }

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      id: json['id'] as int?,
      nom: json['nom'],
      posologie: json['posologie'],
      dateD: json['dateD'],
      seuil: json['seuil'],
      prix: json['prix'],
      dateP: json['dateP'],
      stock: json['stock'],
      idOrd: json['idOrd'],
      pilulesParPaquet: json['pilulesParPaquet'], // Add this line
    );
  }
}
