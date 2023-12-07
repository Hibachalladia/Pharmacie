
  import 'package:flutter/material.dart';
  import 'package:notifiation/stockpage.dart';
  import 'ajoutMedicament.dart';
  import 'database_helper.dart';

class ListMedicaments extends StatefulWidget {
  @override
  _ListMedicamentsState createState() => _ListMedicamentsState();
}

class _ListMedicamentsState extends State<ListMedicaments> {
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper as DatabaseHelper; // Use the singleton instance
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Medicaments'),
      ),
      body: FutureBuilder<List<Medicament>>(
        future: dbHelper.getMedicaments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Medicament> medicaments = snapshot.data!;
            return ListView.builder(
              itemCount: medicaments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(medicaments[index].nom),
                  subtitle: Text('Posologie: ${medicaments[index].posologie}'),
                  onTap: () {
                    // Navigate to the detail page or perform any other action
                    // Navigator.pushNamed(context, '/detailMed', arguments: medicaments[index].id);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjoutMedicament()),
          );
          // Refresh the list of medicaments when returning from the AjoutMedicament page
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
