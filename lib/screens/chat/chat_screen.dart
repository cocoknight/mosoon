
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/chat_bubble.dart';
import '../../models/chat_message.dart';



/// Riverpod용 ChatProvider
class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void sendMessage(String text) {
    _messages.add(ChatMessage(text: text, sender: MessageSender.user));
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      _messages.add(ChatMessage(text: "추천을 준비 중이에요!", sender: MessageSender.bot));
      notifyListeners();
    });
  }
}

/// Provider 등록
final chatProvider = ChangeNotifierProvider<ChatProvider>((ref) => ChatProvider());

/// ChatScreen 위젯
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatProvider).sendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider).messages;

    return Scaffold(
      appBar: AppBar(title: const Text("생활 큐레이터 챗봇")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "메시지를 입력하세요...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}