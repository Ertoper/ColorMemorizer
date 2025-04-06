import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),
          // Затемнение
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // Основной контент
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Заголовок
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: 'C', style: TextStyle(color: Colors.red)),
                      TextSpan(
                        text: 'o',
                        style: TextStyle(color: Colors.green),
                      ),
                      TextSpan(text: 'l', style: TextStyle(color: Colors.blue)),
                      TextSpan(
                        text: 'o',
                        style: TextStyle(color: Colors.yellow),
                      ),
                      TextSpan(
                        text: 'r',
                        style: TextStyle(color: Colors.purple),
                      ),
                      TextSpan(
                        text: 'Memorizer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                // Кнопка "play"
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LevelSelectionPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFC300),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Play",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Кнопка для перехода в "liderboards"
                ElevatedButton(
                  onPressed: () {
                    print("LeaderBoard Button Pressed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFC300),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "LeaderBoard",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Кнопка для перехода на страницу "About Page"
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
          );
        },
        backgroundColor: Color(0xFFFFC300),
        child: Icon(Icons.info, color: Colors.black),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class LevelSelectionPage extends StatelessWidget {
  final int numberOfLevels = 30; // Количество уровней

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),
          // Затемнение
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // Контент
          Positioned.fill(
            child: Column(
              children: [
                AppBar(
                  title: Text('Select Level'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.white,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: numberOfLevels,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final levelNumber = index + 1; // Номер уровня
                        return ElevatedButton(
                          onPressed: () {
                            print('Level $levelNumber selected');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFC300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Center(
                            child: Text(
                              '$levelNumber',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003566),
      appBar: AppBar(
        title: Text('About Page'),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF003566),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'This mobile game challenges players to memorize a sequence of colors and reproduce it correctly across different levels.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Credits',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Developed by Tungatar Ersayyn and Roman Bushnyak in the scope of the course "Crossplatform Development" at Astana IT University.\nMentor (Teacher): Assistant Professor Abzal Kyzyrkanov',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
