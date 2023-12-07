import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Medicament {
  int? id;
  String nom; // or name, choose one
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
    required this.nom, // or name, choose one
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
      'nom': nom, // or name, choose one
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
      nom: map['nom'], // or name, choose one
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
      nom: json['nom'], // or name, choose one
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

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'medicaments_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE medicaments(
          id INTEGER PRIMARY KEY,
          nom TEXT,
          posologie TEXT,
          dateD TEXT,
          seuil TEXT,
          prix REAL,
          dateP TEXT,
          stock INTEGER,
          idOrd INTEGER,
          pilulesParPaquet INTEGER, 
          FOREIGN KEY (idOrd) REFERENCES ordonnance(id)
        )
      ''');
    });
  }

  Future<int> insertMedicament(Medicament medicament) async {
    final db = await database;
    return await db.insert('medicaments', medicament.toMap());
  }

  Future<List<Medicament>> getMedicaments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medicaments');
    return List.generate(maps.length, (i) {
      return Medicament.fromMap(maps[i]);
    });
  }

  Future<int> updateMedicament(Medicament medicament) async {
    final db = await database;
    return await db.update('medicaments', medicament.toMap(), where: 'id = ?', whereArgs: [medicament.id]);
  }

  Future<int> deleteMedicament(int id) async {
    final db = await database;
    return await db.delete('medicaments', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> replenishStock(int medicamentId, int newStock) async {
    final db = await database;
    return await db.rawUpdate('''
      UPDATE medicaments
      SET stock = ?
      WHERE id = ?
    ''', [newStock, medicamentId]);
  }
}

/*
class Medicament {
  int? id;
  String nom; // or name, choose one
  String posologie;
  String dateD;
  String seuil;
  double prix;
  String dateP;
  int stock;
  int? idOrd;

  Medicament({
    this.id,
    required this.nom, // or name, choose one
    required this.posologie,
    required this.dateD,
    required this.seuil,
    required this.prix,
    required this.dateP,
    required this.stock,
    this.idOrd,
  });

  // Convert a Medicament object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom, // or name, choose one
      'posologie': posologie,
      'dateD': dateD,
      'seuil': seuil,
      'prix': prix,
      'dateP': dateP,
      'stock': stock,
      'idOrd': idOrd,
    };
  }

  // Convert a Map into a Medicament object
  factory Medicament.fromMap(Map<String, dynamic> map) {
    return Medicament(
      id: map['id'],
      nom: map['nom'], // or name, choose one
      posologie: map['posologie'],
      dateD: map['dateD'],
      seuil: map['seuil'],
      prix: map['prix'],
      dateP: map['dateP'],
      stock: map['stock'],
      idOrd: map['idOrd'],
    );
  }

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      id: json['id'] as int?,
      nom: json['nom'], // or name, choose one
      posologie: json['posologie'],
      dateD: json['dateD'],
      seuil: json['seuil'],
      prix: json['prix'],
      dateP: json['dateP'],
      stock: json['stock'],
      idOrd: json['idOrd'],
    );
  }
}

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'medicaments_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE medicaments(
          id INTEGER PRIMARY KEY,
          nom TEXT,
          posologie TEXT,
          dateD TEXT,
          seuil TEXT,
          prix REAL,
          dateP TEXT,
          stock INTEGER,
          idOrd INTEGER,
          FOREIGN KEY (idOrd) REFERENCES ordonnance(id)
        )
      ''');
    });
  }

  Future<int> insertMedicament(Medicament medicament) async {
    final db = await database;
    return await db.insert('medicaments', medicament.toMap());
  }

  Future<List<Medicament>> getMedicaments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medicaments');
    return List.generate(maps.length, (i) {
      return Medicament.fromMap(maps[i]);
    });
  }

  Future<int> updateMedicament(Medicament medicament) async {
    final db = await database;
    return await db.update('medicaments', medicament.toMap(), where: 'id = ?', whereArgs: [medicament.id]);
  }

  Future<int> deleteMedicament(int id) async {
    final db = await database;
    return await db.delete('medicaments', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> replenishStock(int medicamentId, int newStock) async {
    final db = await database;
    return await db.rawUpdate('''
      UPDATE medicaments
      SET stock = ?
      WHERE id = ?
    ''', [newStock, medicamentId]);
  }
}
*/