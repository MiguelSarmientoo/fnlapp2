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
  bool isPlaying = false; // Estado de la reproducción

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() {
  flutterTts.setCompletionHandler(() async {
    print('TTS completó la reproducción del mensaje.');
    await Future.delayed(Duration(milliseconds: 100));  // Pequeña pausa
    if (mounted) {
      setState(() {
        isPlaying = false;
        print('El estado de isPlaying es: $isPlaying');
      });
    }
  });

  flutterTts.setCancelHandler(() {
    print('TTS canceló la reproducción.');
    if (mounted) {
      setState(() {
        isPlaying = false;
      });
    }
  });

  flutterTts.setErrorHandler((message) {
    print('TTS encontró un error: $message');
    if (mounted) {
      setState(() {
        isPlaying = false;
      });
    }
  });
}

  void _speakMessage() async {
  if (isPlaying) {
    await flutterTts.stop();
    print('Se detuvo la reproducción del mensaje.');
    setState(() {
      isPlaying = false;
    });
  } else {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.7);

    print('Iniciando la reproducción del mensaje: "${widget.message}"');
    setState(() {
      isPlaying = true;
    });
    await flutterTts.speak(widget.message);
  }
  print('El estado de isPlaying es: $isPlaying');
}


  List<TextSpan> _buildTextSpans(String text) {
    List<TextSpan> spans = [];
    final RegExp urlRegExp = RegExp(r'(https?://[^\s()<>"]+)');
    final RegExp boldRegExp = RegExp(r'\*\*(.*?)\*\*');
    final RegExp italicRegExp = RegExp(r'\[Ver video aquí\]');
    final RegExp combinedRegExp = RegExp(r'(https?://[^\s()<>"]+)|(\*\*(.*?)\*\*)|(\[Ver video aquí\])');

    final matches = combinedRegExp.allMatches(text);

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(color: widget.userType != 1 ? Colors.white : Colors.black),
        ));
        print("Valor de widget.userType: ${widget.userType}");
        print("Tipo de widget.userType: ${widget.userType.runtimeType}");
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
              } else {
                print('No se puede abrir el enlace: $url');
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

  String videoThumbnailUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe3IymTZ4kS68lCty_j3iy0oSOIGiVk6Zw2A&usqp=CAU';

  @override
  Widget build(BuildContext context) {
    print("ChatMessage widget se está reconstruyendo con $isPlaying");
    return Column(
      crossAxisAlignment: widget.userType != 1 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        widget.userType != 1
            ? Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Usted',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6.0),
                      CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.asset(
                            widget.userType != 1
                                ? 'assets/user_img.jpg'
                                : 'assets/logo_funcy_scale.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          widget.userType != 1
                              ? 'assets/user_img.jpg'
                              : 'assets/logo_funcy_scale.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      'Funcy',
                      style: TextStyle(
                        color: Colors.black,
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
              color: widget.userType != 1
                  ? Color.fromARGB(255, 39, 139, 70)
                  : Color(0xFFF2F7FB),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.message.contains('https://') || widget.message.contains('http://'))
                  Column(
                    children: [
                      Image.network(
                        videoThumbnailUrl,
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
                        color: widget.userType != 1
                            ? Color.fromARGB(255, 226, 226, 226)
                            : Color.fromARGB(255, 101, 101, 101),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.volume_off : Icons.volume_up,
                        size: 20.0,
                        color: widget.userType != 1
                            ? Color.fromARGB(255, 226, 226, 226)
                            : Color.fromARGB(255, 101, 101, 101),
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