import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _todoList = [];
  Color _backgroundColor = Colors.white;
  AudioPlayer _player = AudioPlayer();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _player.dispose(); // Dispose to free memory
    super.dispose();
  }

  void _addToDo() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _todoList.add(_controller.text);
        _controller.clear();
      }
    });
  }

  void _playMusic(String asset) async {
    try {
      await _player.stop(); // Stop previous audio
      await _player.play(AssetSource("$asset")); // Correct asset path
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeBackgroundSwipe(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity! > 0) {
        // Swipe Right
        _backgroundColor = const Color.fromARGB(255, 240, 6, 138);
      } else if (details.primaryVelocity! < 0) {
        // Swipe Left
        _backgroundColor = const Color.fromARGB(255, 92, 19, 219);
      }
    });
  }

  Widget _buildTodoScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Enter task",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _addToDo,
          child: Text("Add Task"),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _todoList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    _todoList[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundScreen() {
    return GestureDetector(
      onHorizontalDragEnd: _changeBackgroundSwipe, // Detect swipe gesture
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: _backgroundColor,
        alignment: Alignment.center,
      ),
    );
  }

  Widget _buildMusicScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            "assets/music_icon.webp", 
            width: 130,
            height: 130,
          ),
        ),
        Text(
          "Play a Music",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _playMusic("kalimutanka.mp3"),
              child: Text("kalimutan ka"),
            ),
            ElevatedButton(
              onPressed: () => _playMusic("palagi.mp3"),
              child: Text("palagi"),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      _buildTodoScreen(),
      _buildBackgroundScreen(),
      _buildMusicScreen()
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(title: Text("amtmapp")),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "To-Do List"),
          BottomNavigationBarItem(
              icon: Icon(Icons.color_lens), label: "Background"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Music"),
        ],
      ),
    );
  }
}
