import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mosoon/services/firebase_persona_service.dart';
import '../../models/persona.dart';
import '../../providers/persona_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/persona.dart';
import '../../providers/persona_provider.dart';
import '../../services/firebase_persona_service.dart';

class PersonaFormScreen extends ConsumerStatefulWidget {
  final Persona? existing;
  const PersonaFormScreen({this.existing, Key? key}) : super(key: key);

  @override
  ConsumerState<PersonaFormScreen> createState() => _PersonaFormScreenState();
}

class _PersonaFormScreenState extends ConsumerState<PersonaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late String location;
  Map<String, String> preferences = {};

  @override
  void initState() {
    super.initState();
    name = widget.existing?.name ?? '';
    description = widget.existing?.description ?? '';
    location = widget.existing?.location ?? '';
    preferences = widget.existing?.preferences ?? {};
  }

  Future<void> _savePersona() async {
    final persona = Persona(
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      imageUrl: 'assets/images/default.png',
      preferences: preferences,
      location: location,
    );

    final service = FirebasePersonaService();
    if (widget.existing != null) {
      await service.updatePersona(persona);
    } else {
      await service.savePersona(persona);
    }

    ref.read(personaListProvider.notifier).update((list) {
      final updated = list.where((p) => p.id != persona.id).toList();
      return [...updated, persona];
    });

    Navigator.pop(context);
  }

  Future<void> _deletePersona() async {
    final service = FirebasePersonaService();
    final id = widget.existing?.id;
    if (id != null) {
      await service.deletePersona(id);
      ref.read(personaListProvider.notifier).update((list) => list.where((p) => p.id != id).toList());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "페르소나 수정" : "페르소나 등록")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: "이름"),
                onChanged: (val) => name = val,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "설명"),
                onChanged: (val) => description = val,
              ),
              TextFormField(
                initialValue: location,
                decoration: const InputDecoration(labelText: "지역"),
                onChanged: (val) => location = val,
              ),
              TextFormField(
                initialValue: preferences["taste"],
                decoration: const InputDecoration(labelText: "선호 음식"),
                onChanged: (val) => preferences["taste"] = val,
              ),
              TextFormField(
                initialValue: preferences["shopping"],
                decoration: const InputDecoration(labelText: "쇼핑 관심사"),
                onChanged: (val) => preferences["shopping"] = val,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _savePersona,
                child: Text(isEditing ? "수정하기" : "등록하기"),
              ),
              if (isEditing)
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("삭제하기", style: TextStyle(color: Colors.red)),
                  onPressed: _deletePersona,
                ),
            ],
          ),
        ),
      ),
    );
  }
}