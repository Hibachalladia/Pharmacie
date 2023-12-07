import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifiation/database_helper.dart';

class StockPage extends StatefulWidget {
  final Medicament? medicament;

  StockPage({required this.medicament});

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> with AutomaticKeepAliveClientMixin {
  late TextEditingController paquetsController;
  late TextEditingController pillulesController;
  late TextEditingController totalPillulesController;
  late TextEditingController pillulesPrisesController;
  late TextEditingController restePillulesController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    paquetsController = TextEditingController(text: '0');
    pillulesController = TextEditingController(text: '0');
    totalPillulesController = TextEditingController(text: '0');
    pillulesPrisesController = TextEditingController(text: '0');
    restePillulesController = TextEditingController(text: '0');
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'stock_channel_id', // ID du canal
      'Stock Notifications', // Nom du canal

      importance: Importance.max,
      priority: Priority.high,
      // No need for the ticker here, as it's optional
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification
      'Stock bas !', // Titre de la notification
      'Le stock est bas, pensez à renouveler vos médicaments.', // Corps de la notification
      platformChannelSpecifics,
    );
  }




  Future<void> checkStockAndShowNotification() async {
    int paquets = int.tryParse(paquetsController.text) ?? 0;
    int pillulesParPaquet = int.tryParse(pillulesController.text) ?? 0;
    int pillulesPrises = int.tryParse(pillulesPrisesController.text) ?? 0;

    // Calcul du total des pilules
    int totalPillules = paquets * pillulesParPaquet;

    // Calcul du reste des pilules
    int restePillules = totalPillules - pillulesPrises;

    // Mettez à jour le stock dans la base de données
    await DatabaseHelper().replenishStock(widget.medicament?.id ?? 0, totalPillules);

    // Mettez à jour l'état pour refléter les changements
    setState(() {
      widget.medicament?.stock = totalPillules;
      totalPillulesController.text = totalPillules.toString();
      restePillulesController.text = restePillules.toString();
    });

    // Affichez la notification uniquement si le stock est bas
    if (restePillules <= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock bas !'), // Message de l'alerte
          backgroundColor: Colors.red, // Couleur de l'alerte
        ),
      );
      await showNotification(); // Appel à la méthode pour afficher la notification
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // N'oubliez pas d'appeler super.build.

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Page'),
        backgroundColor: Colors.teal, // Couleur teal pour l'app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicament: ${widget.medicament?.nom} ⚕️',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Stock: ${restePillulesController.text} 💊',
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 20),
            TextField(
              controller: paquetsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombre de paquets 📦',
                fillColor: Colors.teal,
              ),
            ),
            TextField(
              controller: pillulesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombre de pilules par paquet 💊',
                fillColor: Colors.teal,
              ),
            ),
            TextField(
              controller: totalPillulesController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Total des pilules 💊',
                fillColor: Colors.teal,
              ),
            ),
            TextField(
              controller: pillulesPrisesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombre de pilules prises 💊',
                fillColor: Colors.teal,
              ),
            ),
            TextField(
              controller: restePillulesController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Reste des pilules 💊',
                fillColor: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await checkStockAndShowNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stock mis à jour avec succès 🎉')),
                );
              },
              child: Text('Mettre à jour le stock'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal, // Couleur teal pour le bouton
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:notifiation/database_helper.dart';

class StockPage extends StatefulWidget {
  final Medicament? medicament;

  StockPage({required this.medicament});

  @override
  _StockPageState createState() => _StockPageState();
}
class _StockPageState extends State<StockPage> with AutomaticKeepAliveClientMixin {
  late TextEditingController paquetsController;
  late TextEditingController pillulesController;
  late TextEditingController totalPillulesController;
  late TextEditingController pillulesPrisesController;
  late TextEditingController restePillulesController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    paquetsController = TextEditingController(text: '0');
    pillulesController = TextEditingController(text: '0');
    totalPillulesController = TextEditingController(text: '0');
    pillulesPrisesController = TextEditingController(text: '0');
    restePillulesController = TextEditingController(text: '0');
  }

  Future<void> showNotification() async {
    // Le reste du code pour la notification reste inchangé
  }

  Future<void> checkStockAndShowNotification() async {
    int paquets = int.tryParse(paquetsController.text) ?? 0;
    int pillulesParPaquet = int.tryParse(pillulesController.text) ?? 0;
    int pillulesPrises = int.tryParse(pillulesPrisesController.text) ?? 0;

    // Calcul du total des pilules
    int totalPillules = paquets * pillulesParPaquet;

    // Calcul du reste des pilules
    int restePillules = totalPillules - pillulesPrises;

    // Mettez à jour le stock dans la base de données
    await DatabaseHelper().replenishStock(widget.medicament?.id ?? 0, totalPillules);

    // Mettez à jour l'état pour refléter les changements
    setState(() {
      widget.medicament?.stock = totalPillules;
      totalPillulesController.text = totalPillules.toString();
      restePillulesController.text = restePillules.toString();
    });

    // Affichez la notification uniquement si le stock est bas

    // Affichez la notification uniquement si le stock est bas
    if (restePillules <= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock bas !'), // Message de l'alerte
          backgroundColor: Colors.red, // Couleur de l'alerte
        ),
      );
      await showNotification(); // Appel à la méthode pour afficher la notification
    }

  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // N'oubliez pas d'appeler super.build.

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Page'),
        backgroundColor: Colors.teal, // Couleur teal pour l'app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicament: ${widget.medicament?.nom} ⚕️',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Stock: ${widget.medicament?.stock} 💊',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: paquetsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombre de paquets 📦',
                fillColor: Colors.teal,
              ),
            ),
            TextField(
              controller: pillulesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombre de pilules par paquet 💊',
                fillColor: Colors.teal,
              ),
            ),
            TextField(
              controller: totalPillulesController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Total des pilules 💊',
                fillColor: Colors.teal,
              ),
            ),
            TextField(
              controller: pillulesPrisesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombre de pilules prises 💊',
                fillColor: Colors.teal,
              ),
            ),
            TextField(
              controller: restePillulesController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Reste des pilules 💊',
                fillColor: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await checkStockAndShowNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stock mis à jour avec succès 🎉')),
                );
              },
              child: Text('Mettre à jour le stock'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal, // Couleur teal pour le bouton
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
class StockPage extends StatefulWidget {
  final Medicament? medicament;

  StockPage({required this.medicament});

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late TextEditingController stockController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    stockController = TextEditingController(text: widget.medicament?.stock.toString());
    initializeNotifications();
  }

  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1', 'channelName',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Stock Alert',
      'The stock of ${widget.medicament?.nom} is running low!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> checkStockAndShowNotification() async {
    int newStock = int.tryParse(stockController.text) ?? 0;
    if (newStock == 1) {
      await showNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicament: ${widget.medicament?.nom}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Stock: ${widget.medicament?.stock}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nouveau stock'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().replenishStock(widget.medicament?.id! ?? 0, int.tryParse(stockController.text) ?? 0);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stock replenished successfully')),
                );
                setState(() {
                  widget.medicament?.stock = int.tryParse(stockController.text) ?? 0;
                });

                // Check if stock is 1 to show the notification
                await checkStockAndShowNotification();
              },
              child: Text('Replenish Stock'),
            ),
          ],
        ),
      ),
    );
  }
}
*/