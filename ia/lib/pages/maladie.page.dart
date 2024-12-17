import 'package:flutter/material.dart';

class DiseaseDiagnosisPage extends StatefulWidget {
  @override
  _DiseaseDiagnosisPageState createState() => _DiseaseDiagnosisPageState();
}

class _DiseaseDiagnosisPageState extends State<DiseaseDiagnosisPage> {
  int currentQuestionIndex = 0;
  Map<String, String> responses = {};
  String? _selectedValue;

  List<Map<String, dynamic>> questions = [
    {
      'question':
          'Votre arbre présente-t-il des taches blanches farineuses sur les feuilles ?',
      'type': 'yes_no',
      'disease': 'Oïdium',
      'image': 'images/qes11.jpg',
    },
    {
      'question': 'Les feuilles sont-elles jaunissantes et sèches ?',
      'type': 'yes_no',
      'disease': 'Oïdium',
      'image': 'images/qes21.jpg',
    },
    {
      'question': 'Les feuilles sont-elles déformées et enroulées ?',
      'type': 'yes_no',
      'disease': 'Oïdium',
      'image': 'images/qes31.jpg',
    },
    {
      'question':
          'Votre arbre présente-t-il une décoloration des feuilles, particulièrement aux bords ?',
      'type': 'yes_no',
      'disease': 'Verticilliose',
      'image': 'images/qes41.jpg',
    },
    {
      'question': 'La croissance de votre arbre semble-t-elle être ralentie ?',
      'type': 'yes_no',
      'disease': 'Verticilliose',
    },
    {
      'question': 'Quel type de tache présente-t-il ?',
      'type': 'dropdown',
      'options': ['Taches jaunes', 'Taches brunes', 'Taches noires'],
      'disease': 'Verticilliose',
    },
    {
      'question':
          'Avez-vous remarqué des sécrétions gommeuses sur les troncs et branches ?',
      'type': 'yes_no',
      'disease': 'Gomose',
      'image': 'images/qes71.jpg',
    },
    {
      'question': 'Votre arbre présente-t-il des fissures sur l’écorce ?',
      'type': 'yes_no',
      'disease': 'Gomose',
      'image': 'images/qes81.jpg',
    },
    {
      'question':
          'Des branches ou des brindilles semblent-elles mortes ou en déclin ?',
      'type': 'yes_no',
      'disease': 'Gomose',
      'image': 'images/qes91.jpg',
    },
    {
      'question':
          'Votre arbre présente-t-il des boules blanches ou cireuses sur les branches ?',
      'type': 'yes_no',
      'disease': 'Cochenille',
      'image': 'images/qes101.jpg',
    },
    {
      'question':
          'Des excréments noirs (moule) sont-ils présents sur les feuilles ou branches ?',
      'type': 'yes_no',
      'disease': 'Cochenille',
      'image': 'images/qes111.png',
    },
    {
      'question': 'Les nouvelles pousses semblent-elles déformées ?',
      'type': 'yes_no',
      'disease': 'Cochenille',
    },
  ];

  void handleYesNoAnswer(String answer) {
    setState(() {
      responses[questions[currentQuestionIndex]['question']] = answer;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        showResult();
      }
    });
  }

  void handleDropdownAnswer(String answer) {
    setState(() {
      responses[questions[currentQuestionIndex]['question']] = answer;
      _selectedValue = answer;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        showResult();
      }
    });
  }

  // Function to show diagnostic result based on answers
  void showResult() {
    String resultMessage = "Aucune maladie détectée.";

    // Diagnose the disease based on responses
    if (responses[
                'Votre arbre présente-t-il des taches blanches farineuses sur les feuilles ?'] ==
            'Oui' &&
        responses['Les feuilles sont-elles jaunissantes et sèches ?'] ==
            'Oui' &&
        responses['Les feuilles sont-elles déformées et enroulées ?'] ==
            'Oui') {
      resultMessage = 'Maladie détectée: Oïdium (Powdery Mildew)';
    } else if (responses['Votre arbre présente-t-il une décoloration des feuilles, particulièrement aux bords ?'] ==
            'Oui' &&
        responses[
                'La croissance de votre arbre semble-t-elle être ralentie ?'] ==
            'Oui' &&
        responses['Quel type de tache présente-t-il ?'] == 'Taches jaunes') {
      resultMessage = 'Maladie détectée: Verticilliose (Verticillium Wilt)';
    } else if (responses[
                'Avez-vous remarqué des sécrétions gommeuses sur les troncs et branches ?'] ==
            'Oui' &&
        responses['Votre arbre présente-t-il des fissures sur l’écorce ?'] ==
            'Oui' &&
        responses[
                'Des branches ou des brindilles semblent-elles mortes ou en déclin ?'] ==
            'Oui') {
      resultMessage = 'Maladie détectée: Gomose (Gummosis)';
    } else if (responses[
                'Votre arbre présente-t-il des boules blanches ou cireuses sur les branches ?'] ==
            'Oui' &&
        responses[
                'Des excréments noirs (moule) sont-ils présents sur les feuilles ou branches ?'] ==
            'Oui' &&
        responses['Les nouvelles pousses semblent-elles déformées ?'] ==
            'Oui') {
      resultMessage = 'Maladie détectée: Cochenille (Scale Insects)';
    }

    // Display the result in a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Résultat du diagnostic',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          content: Text(resultMessage, style: TextStyle(fontSize: 18)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentQuestionIndex = 0; // Reset the questionnaire
                  responses.clear(); // Clear responses
                });
              },
              child: Text('Fermer', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          child: AppBar(
            title: Text(
              'Diagnostic des Plantes',
              style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade900, Colors.green.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Card
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    questions[currentQuestionIndex]['question'],
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Optional Image Section
              if (questions[currentQuestionIndex]['image'] != null &&
                  questions[currentQuestionIndex]['image'] != '')
                Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 5,
                            spreadRadius: 2),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        questions[currentQuestionIndex]['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 30),

              // Yes/No Buttons
              if (questions[currentQuestionIndex]['type'] == 'yes_no')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => handleYesNoAnswer('Oui'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Oui',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => handleYesNoAnswer('Non'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Non',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),

              // Dropdown for multiple-choice questions
              if (questions[currentQuestionIndex]['type'] == 'dropdown')
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: DropdownButtonFormField<String>(
                    value: _selectedValue,
                    onChanged: (String? newValue) {
                      handleDropdownAnswer(newValue!);
                    },
                    items: questions[currentQuestionIndex]['options']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      hintText: 'Sélectionner une option',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.green.shade700, width: 2),
                      ),
                    ),
                    style: TextStyle(fontSize: 18),
                    icon: Icon(Icons.arrow_drop_down_circle,
                        color: Colors.green[700]),
                    iconSize: 30,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
