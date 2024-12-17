import 'package:flutter/material.dart';

class PredictionDureePage extends StatefulWidget {
  @override
  _PredictionDureePageState createState() => _PredictionDureePageState();
}

class _PredictionDureePageState extends State<PredictionDureePage> {
  final _formKey = GlobalKey<FormState>();

  // Parameters
  double acidity = 0.0;
  double humidity = 0.0;
  double peroxideIndex = 0.0;
  String oilType = 'Huile d\'Olive Extra'; // Initial value for oilType
  String exposureToOxygen = 'Non';
  String exposureToLight = 'Non';
  String containerType = 'Étanche (inox/étain)';
  String opaqueContainer = 'Oui';
  double storageTemperature = 20.0;

  // List of oil types for the dropdown (limit to 3 types)
  final List<String> oilTypes = [
    'Huile d\'Olive Extra',
    'Huile d\'Olive Vierge',
    'Huile d\'Olive Courante',
  ];

  // Prediction function
  String predictShelfLife({
    required double acidity,
    required double humidity,
    required double peroxideIndex,
    required String oilType,
    required String exposureToOxygen,
    required String exposureToLight,
    required double storageTemperature,
    required String containerType,
    required String opaqueContainer,
  }) {
    double baseDuration = 24; // Base duration in months

    // Conditions based on the selected oil type
    if (oilType == 'Huile d\'Olive Courante') baseDuration -= 6;
    if (oilType == 'Huile d\'Olive Vierge') baseDuration -= 4;
    if (oilType == 'Huile d\'Olive Extra') baseDuration -= 3;
    if (exposureToOxygen == 'Oui') baseDuration -= 8;
    if (exposureToLight == 'Oui') baseDuration -= 6;
    baseDuration -= acidity * 2;
    if (humidity > 5) baseDuration -= (humidity - 5) * 1.5;
    if (peroxideIndex > 20) baseDuration -= (peroxideIndex - 20) * 0.5;
    if (containerType == 'Plastique') baseDuration -= 8;
    if (opaqueContainer == 'Non') baseDuration -= 5;
    if (storageTemperature > 25)
      baseDuration -= (storageTemperature - 25) * 0.5;

    // Ensure the base duration is not negative
    baseDuration = baseDuration < 0 ? 0 : baseDuration;

    // Calculate a range (minimum and maximum duration) based on the result
    double minDuration = baseDuration - 2; // Example: subtract a small buffer
    double maxDuration = baseDuration + 2; // Example: add a small buffer

    // Ensure the range values are not negative
    minDuration = minDuration < 0 ? 0 : minDuration;
    maxDuration = maxDuration < 0 ? 0 : maxDuration;

    return '${minDuration.toStringAsFixed(1)} mois à ${maxDuration.toStringAsFixed(1)} mois';
  }

  // Show result in a popup dialog with a range
  void showPredictionResult(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Résultat de la Prédiction',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'La durée estimée de conservation de l\'huile est de $result.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prédiction de la Durée',
          style: TextStyle(
              fontFamily: 'Serif', fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade50,
              const Color.fromARGB(255, 188, 255, 188),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paramètres de Prédiction',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Acidité
                _buildNumberInput(
                  label: 'Acidité (%)',
                  onSaved: (value) => acidity = double.parse(value!),
                ),

                // Exposition à l'oxygène
                _buildRadioGroup(
                  label: 'Exposition à l\'oxygène',
                  value: exposureToOxygen,
                  options: ['Oui', 'Non'],
                  onChanged: (value) =>
                      setState(() => exposureToOxygen = value!),
                ),

                // Exposition à la lumière
                _buildRadioGroup(
                  label: 'Exposition à la lumière',
                  value: exposureToLight,
                  options: ['Oui', 'Non'],
                  onChanged: (value) =>
                      setState(() => exposureToLight = value!),
                ),

                // Type de contenant
                _buildRadioGroup(
                  label: 'Type de contenant',
                  value: containerType,
                  options: ['Étanche (inox/étain)', 'Plastique', 'Autre'],
                  onChanged: (value) => setState(() => containerType = value!),
                ),

                // Contenant opaque
                _buildRadioGroup(
                  label: 'Contenant opaque',
                  value: opaqueContainer,
                  options: ['Oui', 'Non'],
                  onChanged: (value) =>
                      setState(() => opaqueContainer = value!),
                ),

                // Température de stockage
                _buildNumberInput(
                  label: 'Température de stockage (°C)',
                  onSaved: (value) => storageTemperature = double.parse(value!),
                ),

                // Dropdown for oil type (Now limited to 3 types)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Type d\'huile',
                      border: OutlineInputBorder(),
                    ),
                    value: oilType,
                    onChanged: (newValue) {
                      setState(() {
                        oilType =
                            newValue!; // Update the state of the selected oilType
                      });
                    },
                    items: oilTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 20),

                // Prediction Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String result = predictShelfLife(
                          acidity: acidity,
                          humidity: humidity,
                          peroxideIndex: peroxideIndex,
                          oilType: oilType,
                          exposureToOxygen: exposureToOxygen,
                          exposureToLight: exposureToLight,
                          storageTemperature: storageTemperature,
                          containerType: containerType,
                          opaqueContainer: opaqueContainer,
                        );
                        showPredictionResult(result);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green.shade600, // Background color
                      foregroundColor: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      elevation: 5, // Shadow effect
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12), // Spacing
                    ),
                    child: Text(
                      'Prédire la Durée',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2, // Add slight letter spacing
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Number Input Field
  Widget _buildNumberInput({
    required String label,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty)
            return 'Veuillez entrer une valeur';
          if (double.tryParse(value) == null) return 'Valeur invalide';
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }

  // Reusable Radio Button Group
  Widget _buildRadioGroup({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: value,
              onChanged: onChanged,
            );
          }).toList(),
        ],
      ),
    );
  }
}
