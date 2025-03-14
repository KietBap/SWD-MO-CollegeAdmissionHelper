import 'package:flutter/material.dart';
import 'dart:async';
import '../services/chat_ai_service.dart';
import '../widgets/typing_indicator.dart';

class ChatBoxAiScreen extends StatefulWidget {
  final String? userId;

  const ChatBoxAiScreen({this.userId, Key? key}) : super(key: key);

  @override
  _ChatBoxAiScreenState createState() => _ChatBoxAiScreenState();
}

class _ChatBoxAiScreenState extends State<ChatBoxAiScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;
  bool isWaitingForResponse = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    final messageStream = _chatService.getMessages(widget.userId);
    if (messageStream != null) {
      messageStream.listen((event) {
        final rawData = event.snapshot.value;
        if (rawData == null || rawData is! Map) {
          return;
        }

        final List<Map<String, dynamic>> tempMessages = [];

        rawData.forEach((timestamp, timestampData) {
          if (timestampData["messages"] is Map<dynamic, dynamic>) {
            timestampData["messages"].forEach((messageId, message) {
              if (message is Map<dynamic, dynamic>) {
                tempMessages.add({
                  "Sender": message["Sender"] ?? "unknown",
                  "Text": (message["Text"] ?? "Unknown message")
                      .replaceAll("\\n", "\n")
                      .replaceAll("*", " ")
                      .trim(),
                  "Timestamp": message["Timestamp"] ??
                      DateTime.now().toUtc().toIso8601String(),
                });
              }
            });
          }
        });

        tempMessages.sort((a, b) => b['Timestamp'].compareTo(a['Timestamp']));

        setState(() {
          _messages.clear();
          _messages.addAll(tempMessages);
        });

        _scrollToBottom();
      }, onError: (error) {
        print("Firebase Stream Error: $error");
      });
    }
  }

  void sendMessage() async {
    if (isWaitingForResponse || widget.userId == null) return;

    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      String timestamp = DateTime.now().toUtc().toIso8601String();
      setState(() {
        _messages.insert(0, {
          "Text": text,
          "Sender": "user",
          "Timestamp": timestamp,
        });
        isWaitingForResponse = true;
        isTyping = true;
      });

      _messageController.clear();
      _scrollToBottom();

      await _chatService.sendMessage(text);

      setState(() {
        isWaitingForResponse = false;
        isTyping = false;
      });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.zero,
            bottomRight: Radius.circular(16),
          ),
        ),
        child: TypingIndicator(),
      ),
    );
  }

  Widget _buildMessage(String? message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isUser ? Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : Radius.circular(16),
          ),
        ),
        child: Text(
          message ?? "Message unavailable",
          style: TextStyle(
              color: isUser ? Colors.white : Colors.black87, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat With AI")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == 0) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[isTyping ? index - 1 : index];
                return _buildMessage(msg["Text"], msg["Sender"] == "user");
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !isWaitingForResponse,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    enableIMEPersonalizedLearning: true,
                    onEditingComplete: sendMessage,
                    decoration: InputDecoration(
                      hintText: isWaitingForResponse
                          ? "Waiting for AI to reply..."
                          : "Enter message...",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: isWaitingForResponse ? null : sendMessage,
                  child: CircleAvatar(
                    backgroundColor:
                        isWaitingForResponse ? Colors.grey : Colors.blueAccent,
                    radius: 24,
                    child: Icon(Icons.send, color: Colors.white),
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
