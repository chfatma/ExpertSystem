import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ia/pages/classify.dart';
import 'package:ia/pages/maladie.page.dart';
import 'package:ia/pages/predictiondure.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> images = [
    'images/logoapp.png',
    // 'images/logoapp2.png',
    //'images/logoapp3.png',
  ];

  int _currentIndex = 0; // Track the current index
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Auto-change images every 3 seconds
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % images.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade50,
              const Color.fromARGB(255, 188, 255, 188)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Système Expert pour l\'Huile d\'Olive \net Détection de Maladies',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Circular Motion Carousel with Square Images
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    double scale = _currentIndex == index
                        ? 1.0
                        : 0.8; // Active image is larger
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: scale, end: scale),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded square
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Indicator Dots
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _currentIndex == index ? 12 : 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.green[800]
                          : Colors.grey[400],
                    ),
                  );
                }),
              ),
              SizedBox(height: 30),

              // Buttons Section
              Column(
                children: [
                  buildCustomButton(
                    context: context,
                    title: 'Classifiez l\'Huile d\'Olive',
                    gradientColors: [Colors.green[600]!, Colors.green[300]!],
                    icon: Icons.oil_barrel,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpertSystemHuileOlivePage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  buildCustomButton(
                    context: context,
                    title: 'Détection de Maladies',
                    gradientColors: [Colors.orange[600]!, Colors.orange[300]!],
                    icon: Icons.health_and_safety,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiseaseDiagnosisPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  buildCustomButton(
                    context: context,
                    title: 'Prédiction de la Durée',
                    gradientColors: [Colors.blue[600]!, Colors.blue[300]!],
                    icon: Icons.timer,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PredictionDureePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomButton({
    required BuildContext context,
    required String title,
    required List<Color> gradientColors,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: gradientColors[0].withOpacity(0.3),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
