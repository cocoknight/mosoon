import 'package:flutter/material.dart';
import '../models/persona.dart';

class PersonaChip extends StatelessWidget {
  final Persona persona;
  final bool isSelected;
  final VoidCallback onTap;

  const PersonaChip({
    Key? key,
    required this.persona,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(persona.name),
      avatar: CircleAvatar(
        backgroundImage: AssetImage(persona.imageUrl),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}