import 'package:flutter/material.dart';
import 'package:spoty_try5/models/character_model.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(character.image!), // Display character image
        title: Text(character.name!), // Display character name
        subtitle: Text(character.status!), // Display additional info
        onTap: () {
          // Handle card tap if needed
        },
      ),
    );
  }
}
