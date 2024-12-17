import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class ChatMessage extends StatefulWidget {
  final String message;
  final String time;
  final int userId;
  final int userType;

  ChatMessage({
    Key? key,
    required this.message,
    required this.time,
    required this.userId,
    required this.userType,
  }) : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() {
    flutterTts.setCompletionHandler(() async {
      setState(() => isPlaying = false);
    });

    flutterTts.setCancelHandler(() {
      setState(() => isPlaying = false);
    });

    flutterTts.setErrorHandler((message) {
      setState(() => isPlaying = false);
    });
  }

  void _speakMessage() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() => isPlaying = false);
    } else {
      await flutterTts.setLanguage("es-ES");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.7);
      setState(() => isPlaying = true);
      await flutterTts.speak(widget.message);
    }
  }

  List<TextSpan> _buildTextSpans(String text) {
    List<TextSpan> spans = [];
    final RegExp combinedRegExp = RegExp(
        r'(https?://[^\s()<>"]+)|(\*\*(.*?)\*\*)|(\[Ver video aquí\])');
    final matches = combinedRegExp.allMatches(text);

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
              color: widget.userType != 1 ? Colors.white : Colors.black),
        ));
      }

      if (match.group(1) != null) {
        final String url = match.group(1) ?? '';
        spans.add(TextSpan(
          text: url,
          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
        ));
      } else if (match.group(2) != null) {
        final String boldText = match.group(3) ?? '';
        spans.add(TextSpan(
          text: boldText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.userType != 1 ? Colors.white : Colors.black,
          ),
        ));
      } else if (match.group(4) != null) {
        spans.add(TextSpan(
          text: '[Ver video aquí] ',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: widget.userType != 1 ? Colors.white : Colors.black,
          ),
        ));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(color: widget.userType != 1 ? Colors.white : Colors.black),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.userType != 1 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    widget.userType != 1 ? 'user_img.jpg' : 'logo_funcy_scale.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 6.0),
              Text(
                widget.userType != 1 ? 'Usted' : 'Funcy',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
        Align(
          alignment: widget.userType != 1 ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              top: widget.userType != 1 ? 4.0 : 0.0,
              bottom: 4.0,
              left: widget.userType != 1 ? 80.0 : 50.0,
              right: widget.userType != 1 ? 50.0 : 80.0,
            ),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: widget.userType != 1 ? Color.fromARGB(143, 154, 82, 212) : Color.fromARGB(232, 242, 247, 251),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.message.contains('http://') || widget.message.contains('https://'))
                  Column(
                    children: [
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe3IymTZ4kS68lCty_j3iy0oSOIGiVk6Zw2A&usqp=CAU',
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 4.0),
                    ],
                  ),
                RichText(
                  text: TextSpan(
                    children: _buildTextSpans(widget.message),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(height: 2.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.time,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: widget.userType != 1 ? Color.fromARGB(255, 226, 226, 226) : Color.fromARGB(255, 101, 101, 101),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.volume_off : Icons.volume_up,
                        size: 20.0,
                        color: widget.userType != 1 ? Color.fromARGB(255, 226, 226, 226) : Color.fromARGB(255, 101, 101, 101),
                      ),
                      onPressed: _speakMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
