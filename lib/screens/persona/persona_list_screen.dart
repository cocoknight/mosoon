import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/persona.dart';
import '../../providers/persona_provider.dart';
import '../../providers/persona_provider.dart';
import '../../screens/persona/persona_form_screen.dart';
import '../../services/firebase_persona_service.dart';

class PersonaListScreen extends ConsumerStatefulWidget {
  const PersonaListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PersonaListScreen> createState() => _PersonaListScreenState();
}

class _PersonaListScreenState extends ConsumerState<PersonaListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersonas();
  }

  Future<void> _loadPersonas() async {
    final service = FirebasePersonaService();
    final personas = await service.fetchPersonas();
    ref.read(personaListProvider.notifier).state = personas;
    setState(() => isLoading = false);
  }             

  Future<void> _selectPersona(Persona persona) async{
  // ✅ 선택된 ID를 상태에 저장
  ref.read(selectedPersonaIdProvider.notifier).state = persona.id;

  // ✅ Firestore에도 저장
  await FirebaseFirestore.instance
      .collection("settings")
      .doc("selectedPersona")
      .set({"id": persona.id});

  Navigator.pop(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("${persona.name} 페르소나가 선택되었습니다")),
  );

}

  void _editPersona(Persona persona) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonaFormScreen(existing: persona),
      ),
    ).then((_) => _loadPersonas());
  }

  void _deletePersona(Persona persona) async {
    final service = FirebasePersonaService();
    await service.deletePersona(persona.id);
    await _loadPersonas();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${persona.name} 페르소나가 삭제되었습니다")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final personas = ref.watch(personaListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("페르소나 목록")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : personas.isEmpty
              ? const Center(child: Text("등록된 페르소나가 없습니다"))
              : ListView.builder(
                  itemCount: personas.length,
                  itemBuilder: (context, index) {
                    final persona = personas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(persona.name),
                        subtitle: Text(persona.description),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: () => _selectPersona(persona),
                              child: const Text("선택", style: TextStyle(color: Colors.blue)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editPersona(persona),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deletePersona(persona),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}