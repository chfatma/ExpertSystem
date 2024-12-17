import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpertSystemHuileOlivePage extends StatefulWidget {
  @override
  _ExpertSystemHuileOlivePageState createState() =>
      _ExpertSystemHuileOlivePageState();
}

class _ExpertSystemHuileOlivePageState
    extends State<ExpertSystemHuileOlivePage> {
  final TextEditingController _polyphenolsController = TextEditingController();
  final TextEditingController _acidityController = TextEditingController();
  final TextEditingController _tocopherolController = TextEditingController();
  final TextEditingController _fruitMedianController = TextEditingController();
  final TextEditingController _defautMedianController = TextEditingController();

  // Function to call Flask API and classify the oil
  Future<void> classifyOil() async {
    // Validate that polyphenols are not empty
    if (_polyphenolsController.text.isEmpty) {
      // Show an error dialog if polyphenols are empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text(
            'Le champ des polyphénols ne peut pas être vide.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return;
    }

    // Retrieve user inputs and parse them to doubles
    final double polyphenols =
        double.tryParse(_polyphenolsController.text) ?? 0;
    final double acidity = double.tryParse(_acidityController.text) ?? 0;
    final double tocopherol = double.tryParse(_tocopherolController.text) ?? 0;
    final double fruitMedian =
        double.tryParse(_fruitMedianController.text) ?? 0;
    final double defautMedian =
        double.tryParse(_defautMedianController.text) ?? 0;

    // Make the HTTP request to the Flask API
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/classify_oil'), // Flask API URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'polyphenols': polyphenols,
        'acidity': acidity,
        'tocopherol': tocopherol,
        'fruit_median': fruitMedian,
        'defaut_median': defautMedian,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      final String oilType = data['oil_type'];

      // Show the result in a dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Résultat'),
          content: Text(
            'La classification est: $oilType',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      );
    } else {
      // If the request fails, show an error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text(
            'Erreur de connexion au serveur.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expert System: Huile d\'Olive'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Entrez les caractéristiques de l\'huile:',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800]),
            ),
            SizedBox(height: 30),
            _buildTextField('Polyphénols', _polyphenolsController),
            SizedBox(height: 15),
            _buildTextField('Acidité (%)', _acidityController),
            SizedBox(height: 15),
            _buildTextField('Tocophérol (Vitamine E)', _tocopherolController),
            SizedBox(height: 15),
            _buildTextField('Médiane de Fruité', _fruitMedianController),
            SizedBox(height: 15),
            _buildTextField('Médiane de Défaut', _defautMedianController),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: classifyOil,
                child: Text(
                  'Classer',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25), // Increased border radius for a more modern look
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a styled TextField
  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15), // Rounded corners for the container
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8, // Softer blur for a more elegant effect
            offset: Offset(0, 4), // Slight offset for a floating effect
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16, color: Colors.green[800]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
