import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void sendMessage(String text) {
    _messages.add(ChatMessage(text: text, sender: MessageSender.user));
    notifyListeners();

    // 간단한 봇 응답 (추후 AI 추천으로 대체 가능)
    Future.delayed(Duration(milliseconds: 500), () {
      _messages.add(ChatMessage(text: "추천을 준비 중이에요!", sender: MessageSender.bot));
      notifyListeners();
    });
  }
}