import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'location.dart';

void main() {
  runApp(MaterialApp(
    home: FirefighterChat(),
  ));
}

class FirefighterChat extends StatefulWidget {
  final XFile? initialPicture;

  FirefighterChat({Key? key, this.initialPicture}) : super(key: key);

  @override
  _FirefighterChatState createState() => _FirefighterChatState();
}

class _FirefighterChatState extends State<FirefighterChat> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController =
            CameraController(cameras[0], ResolutionPreset.veryHigh);
        await _cameraController.initialize();
      } else {
        print("No available cameras");
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'FireFighters',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lumanosimo',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).hintColor,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  hintText: 'Send a message',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt), // Camera icon
                        onPressed: () {
                          _openCamera(); // Call _openCamera when pressing the camera button
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_on), // Location icon
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          _handleSubmitted(_textController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCamera() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          cameraController: _cameraController,
          onPictureTaken: _handlePictureTaken,
        ),
      ),
    );
  }

  void _handlePictureTaken(XFile picture) {
    print("Picture taken successfully: ${picture.path}");
    ChatMessage message = ChatMessage(
      text: 'Image:',
      imagePath: picture.path,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }
}

class CameraScreen extends StatelessWidget {
  final CameraController cameraController;
  final Function(XFile) onPictureTaken;

  CameraScreen({
    required this.cameraController,
    required this.onPictureTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CameraPreview(cameraController),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        final XFile picture =
                            await cameraController.takePicture();
                        onPictureTaken(picture);
                        Navigator.pop(context);
                      } catch (e) {
                        print("Error taking a picture: $e");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Icon(Icons.circle, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, this.imagePath = ''});

  final String text;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              child: Text('User'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'User',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                if (imagePath.isNotEmpty) _buildImage(context),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildImage(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0), // Add rounded corners
      border: Border.all(
        color: Colors.black38, // Add a border color
        width: 1.0,
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0), // Clip content to rounded corners
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
      ),
    ),
  );
}

}

