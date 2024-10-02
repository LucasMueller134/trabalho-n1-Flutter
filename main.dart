import 'package:flutter/material.dart';

void main() {
  runApp(EmotionDiaryApp());
}

class EmotionDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diário de Emoções',
      theme: ThemeData(
        primaryColor: Color(0xFF61d4b0), // Azul Claro
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8ee696), // Verde Claro
        ),
        scaffoldBackgroundColor: Color(0xFFecedd5), // Bege Claro
        appBarTheme: AppBarTheme(
          color: Color(0xFF61d4b0), // Azul Claro
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFbaf77c), // Amarelo Claro
        ),
      ),
      home: EmotionListScreen(),
    );
  }
}

class EmotionListScreen extends StatefulWidget {
  @override
  _EmotionListScreenState createState() => _EmotionListScreenState();
}

class _EmotionListScreenState extends State<EmotionListScreen> {
  List<Map<String, String>> _emotions = [];
  List<String> categories = ['Feliz', 'Triste', 'Surpreso', 'Bravo', 'Amor', 'Confuso'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registros de Emoções'),
        actions: [
          IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryScreen(categories: categories)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _emotions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: _getEmotionIcon(_emotions[index]['emotion']!),
            title: Text(_emotions[index]['emotion']!),
            subtitle: Text(_emotions[index]['note']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmotionDetailScreen(emotion: _emotions[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmotionScreen(onSave: _addEmotion, categories: categories)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addEmotion(String emotion, String note) {
    setState(() {
      _emotions.add({'emotion': emotion, 'note': note, 'date': DateTime.now().toString()});
    });
  }

  Icon _getEmotionIcon(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Icon(Icons.sentiment_satisfied, color: Colors.green);
      case 'Triste':
        return Icon(Icons.sentiment_dissatisfied, color: Colors.blue);
      case 'Surpreso':
        return Icon(Icons.sentiment_neutral, color: Colors.yellow);
      case 'Bravo':
        return Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);
      case 'Amor':
        return Icon(Icons.favorite, color: Colors.pink);
      case 'Confuso':
        return Icon(Icons.help_outline, color: Colors.grey);
      default:
        return Icon(Icons.sentiment_satisfied);
    }
  }
}

class AddEmotionScreen extends StatefulWidget {
  final Function(String, String) onSave;
  final List<String> categories;

  AddEmotionScreen({required this.onSave, required this.categories});

  @override
  _AddEmotionScreenState createState() => _AddEmotionScreenState();
}

class _AddEmotionScreenState extends State<AddEmotionScreen> {
  String? _selectedEmotion;
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Emoção'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_selectedEmotion != null && _noteController.text.isNotEmpty) {
                widget.onSave(_selectedEmotion!, _noteController.text);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Selecione uma emoção'),
              value: _selectedEmotion,
              onChanged: (newValue) {
                setState(() {
                  _selectedEmotion = newValue;
                });
              },
              items: widget.categories.map<DropdownMenuItem<String>>((emotion) {
                return DropdownMenuItem<String>(
                  value: emotion,
                  child: Text(emotion),
                );
              }).toList(),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Nota sobre sua emoção'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmotionDetailScreen extends StatelessWidget {
  final Map<String, String> emotion;

  EmotionDetailScreen({required this.emotion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Emoção'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data: ${emotion['date']}'),
            SizedBox(height: 10),
            Text('Emoção: ${emotion['emotion']}'),
            SizedBox(height: 10),
            Text('Nota: ${emotion['note']}'),
          ],
        ),
      ),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  final List<String> categories;

  CategoryScreen({required this.categories});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _categoryController = TextEditingController();

  void _addCategory() {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        widget.categories.add(_categoryController.text);
        _categoryController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias de Emoções'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Adicionar nova categoria'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCategory,
              child: Text('Adicionar Categoria'),
              style: ElevatedButton.styleFrom(
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.categories[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
