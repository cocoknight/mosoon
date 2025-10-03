// class Persona {
//   final String id;
//   final String name;
//   final String description;
//   final String imageUrl;

//   Persona({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//   });
// }

class Persona {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  final Map<String, String> preferences; // 예: {"taste": "매운 음식", "shopping": "패션"}
  final String location; // 예: "서울", "화성시"

  Persona({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.preferences,
    required this.location,
  });

 //TOAN : 09/21/2025. 페르소나 등록 UI + 로직
 Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'preferences': preferences,
    'location': location,
  };

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    preferences: Map<String, String>.from(json['preferences']),
    location: json['location'],
  );



}
