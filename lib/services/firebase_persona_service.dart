//Firebase와 연동한 페르소나 저장/수정/삭제/불러오기 용도

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/persona.dart';

class FirebasePersonaService {
  final _collection = FirebaseFirestore.instance.collection('personas');

  Future<void> savePersona(Persona persona) async {
    await _collection.doc(persona.id).set(persona.toJson());
  }

  Future<void> updatePersona(Persona persona) async {
    await _collection.doc(persona.id).update(persona.toJson());
  }

  Future<void> deletePersona(String id) async {
    await _collection.doc(id).delete();
  }

  Future<List<Persona>> fetchPersonas() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => Persona.fromJson(doc.data())).toList();
  }
}
