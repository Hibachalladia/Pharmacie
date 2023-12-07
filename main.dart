import 'package:flutter/material.dart';
import 'package:notifiation/stockpage.dart';
import 'ajoutMedicament.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get medicament => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/listMed': (context) => ListMedicaments(),
        '/ajoutMed': (context) => AjoutMedicament(),
        '/stock': (context) =>StockPage(medicament: medicament) // Pass Medicament object when navigating
      },
      initialRoute: '/listMed',
    );
  }
}

class ListMedicaments extends StatefulWidget {
  @override
  _ListMedicamentsState createState() => _ListMedicamentsState();
}

class _ListMedicamentsState extends State<ListMedicaments> {
  late List<Medicament> medicaments = [];

  @override
  void initState() {
    super.initState();
    _refreshMedicamentList();
  }

  void _refreshMedicamentList() async {
    medicaments = await DatabaseHelper().getMedicaments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Text(
                  "MyPharmaBox",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.teal.shade400,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                return List<ListTile>.generate(5, (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 20, right: 20),
              itemCount: medicaments.length,
              itemBuilder: (context, index) {
                final medicament = medicaments[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    leading: Icon(
                      Icons.arrow_right,
                      color: Colors.orange,
                      size: 20,
                    ),
                    title: Text(
                      medicament.nom ?? 'A/N',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.teal, size: 25),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Confirmer suppression'),
                                  content: Text(
                                    'Voulez-vous vraiment supprimer cet élément ?',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Annuler'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Supprimer'),
                                      onPressed: () {
                                        setState(() {
                                          medicaments.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.inventory_2,
                            color: Colors.teal,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StockPage(medicament: medicament),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _showUpdateDeleteDialog(context, medicament);
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal.shade400),
              padding: MaterialStateProperty.all(
                EdgeInsets.all(16.0),
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
            ),
            onPressed: () {
              _showUpdateDeleteDialog(context, null); // Passing null as the medicament parameter for adding a new item
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ajouter',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _showUpdateDeleteDialog(BuildContext context, Medicament? medicament) async {
    TextEditingController nomController = TextEditingController();
    TextEditingController posologieController = TextEditingController();
    TextEditingController dateDController = TextEditingController();
    TextEditingController seuilController = TextEditingController(); // Updated
    TextEditingController prixController = TextEditingController();
    TextEditingController datePController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    TextEditingController pillulesController = TextEditingController(); // Updated

    // If updating an existing item, fill the text controllers with existing data
    if (medicament != null) {
      nomController.text = medicament.nom ?? '';
      posologieController.text = medicament.posologie ?? '';
      dateDController.text = medicament.dateD ?? '';
      seuilController.text = medicament.seuil ?? ''; // Updated
      prixController.text = medicament.prix?.toString() ?? '';
      datePController.text = medicament.dateP ?? '';
      stockController.text = medicament.stock?.toString() ?? ''; // Updated
      pillulesController.text = medicament.pilulesParPaquet?.toString() ?? ''; // Updated
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(medicament != null ? 'Update Medicament' : 'Add Medicament'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: posologieController,
                  decoration: InputDecoration(labelText: 'Posologie'),
                ),
                TextField(
                  controller: dateDController,
                  decoration: InputDecoration(labelText: 'DateD'),
                ),
                TextField(
                  controller: seuilController,
                  decoration: InputDecoration(labelText: 'Seuil'), // Updated
                ),
                TextField(
                  controller: prixController,
                  decoration: InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: datePController,
                  decoration: InputDecoration(labelText: 'DateP'),
                ),

                TextField(
                  controller: pillulesController,
                  decoration: InputDecoration(labelText: 'Stock'), // Updated
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(medicament != null ? 'Update' : 'Save'),
              onPressed: () async {
                Medicament updatedMedicament = Medicament(
                  id: medicament?.id,
                  nom: nomController.text,
                  posologie: posologieController.text,
                  dateD: dateDController.text,
                  seuil: seuilController.text, // Updated
                  prix: double.tryParse(prixController.text) ?? 0.0,
                  dateP: datePController.text,
                  stock: int.tryParse(stockController.text) ?? 0,
                  pilulesParPaquet: int.tryParse(pillulesController.text) ?? 0, // Updated
                );

                if (medicament != null) {
                  await DatabaseHelper().updateMedicament(updatedMedicament);
                } else {
                  await DatabaseHelper().insertMedicament(updatedMedicament);
                }

                Navigator.of(context).pop();
                _refreshMedicamentList();
              },
            ),
            if (medicament != null)
              TextButton(
                child: Text('Delete'),
                onPressed: () async {
                  await DatabaseHelper().deleteMedicament(medicament.id!);
                  Navigator.of(context).pop();
                  _refreshMedicamentList();
                },
              ),
          ],
        );
      },
    );
  }
}
