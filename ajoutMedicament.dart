import 'package:flutter/material.dart';
import 'database_helper.dart' as DBHelper; // Use a prefix for the database_helper.dart file
import 'database_helper.dart';
import 'medicament.dart' as MedicamentClass; // Use a prefix for the medicament.dart file

class AjoutMedicament extends StatefulWidget {
  @override
  _AjoutMedicamentState createState() => _AjoutMedicamentState();
}

class _AjoutMedicamentState extends State<AjoutMedicament> {
  late DBHelper.DatabaseHelper dbHelper;
  late TextEditingController nomController;
  late TextEditingController posologieController;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.DatabaseHelper(); // Use the prefix for the database_helper.dart file
    nomController = TextEditingController();
    posologieController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicament'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: posologieController,
              decoration: InputDecoration(labelText: 'Posologie'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print("Adding a new medicament...");
                await dbHelper.insertMedicament(
                Medicament( // Use the prefix for the medicament.dart file
                    nom: nomController.text,
                    posologie: posologieController.text,
                    dateD: DateTime.now().toString(),
                    seuil: "",
                    prix: 0.0,
                    dateP: DateTime.now().toString(),
                    stock: 0,
                    pilulesParPaquet: 0,
                  ),
                );
                print("Medicament added successfully!");

                // Navigate back to the list of medicaments
                Navigator.pop(context);
              },
              child: Text('Add Medicament'),
            ),
          ],
        ),
      ),
    );
  }
}
