import 'package:flutter/material.dart';
import 'dart:async';

import '../services/chat_ai_service.dart';
import '../state/typing_indicator.dart';

class ChatBoxAiScreen extends StatefulWidget {
  @override
  _ChatBoxAiScreenState createState() => _ChatBoxAiScreenState();
}

class _ChatBoxAiScreenState extends State<ChatBoxAiScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false; // Trạng thái AI đang gõ
  bool isWaitingForResponse = false; // Không cho gửi khi AI đang trả lời

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (isWaitingForResponse) return; // Không cho gửi nếu AI chưa phản hồi

    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.insert(0, {"text": text, "sender": "user"});
        isTyping = true;
        isWaitingForResponse = true; // Chặn gửi tiếp khi AI chưa trả lời
      });

      _messageController.clear();
      _scrollToBottom();

      // Gửi tin nhắn đến AI và chờ phản hồi
      String aiResponse = await _chatService.sendMessage(text);

      setState(() {
        isTyping = false;
        isWaitingForResponse = false; // Cho phép gửi tin nhắn mới
        _messages.insert(0, {"text": aiResponse, "sender": "ai"});
      });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessage(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
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
          message,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat với AI")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == 0) {
                  return _buildTypingIndicator(); // Hiển thị animation typing
                }
                final msg = _messages[isTyping ? index - 1 : index];
                return _buildMessage(msg["text"], msg["sender"] == "user");
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
                      hintText: isWaitingForResponse ? "Đang chờ AI trả lời..." : "Nhập tin nhắn...",
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  onTap: isWaitingForResponse ? null : sendMessage, // Chặn gửi khi AI chưa trả lời
                  child: CircleAvatar(
                    backgroundColor: isWaitingForResponse ? Colors.grey : Colors.blueAccent,
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

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.zero,
            bottomRight: Radius.circular(16),
          ),
        ),
        child: TypingIndicator(), // Animation 3 chấm
      ),
    );
  }
}
