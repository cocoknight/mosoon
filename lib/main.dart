import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosoon/firebase_options.dart';
import 'package:mosoon/screens/dashboard/dashboard_screen.dart';
import 'package:mosoon/screens/chat/chat_screen.dart';
import 'package:mosoon/screens/persona/persona_form_screen.dart';
// import 'package:mosoon/screens/memo/photo_memo_screen.dart';
// import 'package:mosoon/screens/schedule/schedule_screen.dart';
// import 'package:mosoon/screens/share/share_screen.dart';

// void main() {
//   runApp(
//     const ProviderScope(
//       child: MosoonApp(),
//     ),
//   );
// }

//TOAN : 09/21/2025. Firebase initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        fontFamily: 'Pretendard',
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        // '/memo': (context) => const MemoScreen(),
        // '/schedule': (context) => const ScheduleScreen(),
        '/chat': (context) => const ChatScreen(),
        // '/share': (context) => const ShareScreen(),
         '/persona/form': (context) => const PersonaFormScreen(),
      },
    );
  }
}