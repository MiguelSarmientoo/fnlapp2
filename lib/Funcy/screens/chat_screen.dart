import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../widgets/chat_message.dart';
import '../widgets/chat_box_footer.dart';
import '../widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final int userId;

  ChatScreen({required this.userId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  int _limit = 20;
  int _offset = 0;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchMessages(); 
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore) {
      _loadMoreMessages();
    }
  }

Future<void> _fetchMessages({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() {
        _loadingMore = true;
      });
    }

    final url = Uri.parse(
        'http://localhost:3000/api/messages/filtered?userId=${widget.userId}&limit=$_limit&offset=$_offset');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          if (isLoadMore) {
            messages.addAll(data.map((item) {
              return {
                'id': item['id']?.toString() ?? '',
                'text': item['content'] ?? '',
                'time': item['created_at'] != null
                    ? DateFormat('HH:mm').format(DateTime.parse(item['created_at']))
                    : '',
                'user_id': item['user_id'] ?? 0,
                'created_at': item['created_at'] ?? '',
              };
            }).toList());
            _loadingMore = false;
          } else {
            messages = data.map((item) {
              return {
                'id': item['id']?.toString() ?? '',
                'text': item['content'] ?? '',
                'time': item['created_at'] != null
                    ? DateFormat('HH:mm').format(DateTime.parse(item['created_at']))
                    : '',
                'user_id': item['user_id'] ?? 0,
                'created_at': item['created_at'] ?? '',
              };
            }).toList();
          }
          _offset += _limit;
        });
      } else {
        print('Error al obtener mensajes: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
    }
  }

    Future<void> _loadMoreMessages() async {
    // Evitar cargar más si ya estamos en proceso de cargar
    if (_loadingMore) return;
    await _fetchMessages(isLoadMore: true);
  }


  Future<void> _sendMessage(String text) async {
    final url = Uri.parse('http://localhost:3000/api/guardarMensaje');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': text,
          'userId': widget.userId,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        setState(() {
          messages.insert(
            0,
            {
              'id': responseData['id'] ?? '',
              'text': text,
              'time': DateFormat('HH:mm').format(DateTime.now()),
              'user_id': widget.userId,
              'created_at': responseData['created_at'] ?? '',
            },
          );
        });

        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

        _getBotResponse(text);
      } else {
        print('Error al enviar el mensaje: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
    }
  }

  Future<void> _getBotResponse(String userMessage) async {
  if (userMessage == null || userMessage.isEmpty) {
    print('Mensaje del usuario es nulo o vacío');
    return;
  }

  // Crear el historial de chat actual
  final List<Map<String, dynamic>> chatHistory = messages.map((msg) {
    return {
      'role': msg['user_id'] == widget.userId ? 'user' : 'assistant',
      'content': msg['text']
    };
  }).toList();

  final url = Uri.parse('http://localhost:3000/api/ask');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'prompt': userMessage,
        'userId': widget.userId,
        'chatHistory': chatHistory // Enviar el historial de chat actual
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final botMessage = responseData['response']?.toString().trim() ?? '';

      final saveBotMessageResponse = await http.post(
        Uri.parse('http://localhost:3000/api/guardarMensajeFromBot'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': botMessage,
          'userId': widget.userId,
        }),
      );

      if (saveBotMessageResponse.statusCode == 201) {
        final responseData = json.decode(saveBotMessageResponse.body);
        setState(() {
          messages.insert(
            0,
            {
              'id': responseData['id']?.toString() ?? '',
              'text': botMessage,
              'time': DateFormat('HH:mm').format(DateTime.now()),
              'user_id': 1,
              'created_at': responseData['created_at'] ?? '',
            },
          );
        });

        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        print('Error al guardar el mensaje del bot: ${saveBotMessageResponse.statusCode}');
      }
    } else {
      print('Error al obtener respuesta del bot: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
    }
  } catch (error) {
    print('Error en la solicitud HTTP: $error');
  }
}


  Color _getAppBarColor() {
    if (_scrollOffset > 100) { // Ajusta este valor según sea necesario
      return Colors.white;
    } else {
      return Colors.white; // Color original del AppBar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco puro para toda la página
      appBar: CustomAppBar(
        scrollOffset: _scrollOffset,
        backgroundColor: _getAppBarColor(),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() {
              _scrollOffset = _scrollController.offset;
            });
          }
          return true;
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                cacheExtent: 1000,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final text = messages[index]['text'] ?? '';
                  final time = messages[index]['time'] ?? '';
                  final user_id = messages[index]['user_id'] ?? '';

                  final userType = user_id == widget.userId ? user_id : 1;

                  return ChatMessage(
                    key: ValueKey(messages[index]['id']), 
                    message: text,
                    time: time,
                    userId: user_id,
                    userType: userType,
                    );

                },
              ),
            ),
            ChatBoxFooter(
              textEditingController: _controller,
              onSendMessage: (text) {
                _sendMessage(text);
                _controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}