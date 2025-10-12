import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosoon/firebase_options.dart';
import 'package:mosoon/screens/dashboard/dashboard_screen.dart';
import 'package:mosoon/screens/chat/chat_screen.dart';
import 'package:mosoon/screens/persona/persona_form_screen.dart';
import 'plugins/strategies/kakao_strategy.dart';
import 'plugins/strategies/openai_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ 전략 인스턴스 생성 → 자동 등록됨
  KakaoStrategy();
  OpenAiStrategy();

  runApp(const ProviderScope(child: MosoonApp()));
}


class MosoonApp extends StatelessWidget {
  const MosoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mosoon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Pretendard', // ✅ 한글 폰트 적용
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/chat': (context) => const ChatScreen(),
        '/persona/form': (context) => const PersonaFormScreen(),
      },
    );
  }
}
