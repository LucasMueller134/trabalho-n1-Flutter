import 'package:flutter/material.dart';

void main() {
  runApp(EmotionDiaryApp());
}

class EmotionDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário de Emoções',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF61d4b0), // Verde Água
          secondary: Color(0xFF8ee696), // Verde Claro
          background: Color(0xFFecedd5), // Cinza Claro
          surface: Color(0xFFbaf77c), // Verde Amarelado
        ),
        scaffoldBackgroundColor: Color(0xFFecedd5), // Cinza Claro
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF61d4b0), // Verde Água na AppBar
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8ee696), // Verde Claro no botão flutuante
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
  List<Map<String, String>> emotions = [];

  void _addEmotion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmotionEditorScreen(
          onSave: (date, emotion, note) {
            setState(() {
              emotions.add({'date': date, 'emotion': emotion, 'note': note});
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diário de Emoções'),
      ),
      body: ListView.builder(
        itemCount: emotions.length,
        itemBuilder: (context, index) {
          final emotion = emotions[index];
          return Card(
            color: Theme.of(context).colorScheme.surface, // Cor dos cartões
            child: ListTile(
              leading: Icon(
                _getEmotionIcon(emotion['emotion']!),
                color: Color(0xFFe8ff65), // Ícone: Amarelo
              ),
              title: Text(emotion['date']!),
              subtitle: Text(emotion['emotion']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmotionDetailScreen(emotion: emotion),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addEmotion,
      ),
    );
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Icons.sentiment_satisfied;
      case 'Triste':
        return Icons.sentiment_dissatisfied;
      case 'Ansioso':
        return Icons.sentiment_neutral;
      default:
        return Icons.sentiment_neutral;
    }
  }
}

class EmotionEditorScreen extends StatefulWidget {
  final Function(String, String, String) onSave;

  EmotionEditorScreen({required this.onSave});

  @override
  _EmotionEditorScreenState createState() => _EmotionEditorScreenState();
}

class _EmotionEditorScreenState extends State<EmotionEditorScreen> {
  final _noteController = TextEditingController();
  String _selectedEmotion = 'Feliz';
  String _selectedDate = DateTime.now().toString().substring(0, 10);

  final List<String> emotions = ['Feliz', 'Triste', 'Ansioso'];

  void _saveEmotion() {
    widget.onSave(
      _selectedDate,
      _selectedEmotion,
      _noteController.text,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Emoção'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveEmotion,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Data: $_selectedDate'),
            DropdownButton<String>(
              value: _selectedEmotion,
              onChanged: (newValue) {
                setState(() {
                  _selectedEmotion = newValue!;
                });
              },
              items: emotions.map<DropdownMenuItem<String>>((String emotion) {
                return DropdownMenuItem<String>(
                  value: emotion,
                  child: Text(emotion),
                );
              }).toList(),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Como você se sentiu?'),
              maxLines: 3,
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
        title: Text(emotion['date']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data: ${emotion['date']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Emoção: ${emotion['emotion']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Notas: ${emotion['note']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
