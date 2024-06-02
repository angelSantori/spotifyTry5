import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spoty_try5/models/character_model.dart';
import 'package:spoty_try5/widgets/zwidgets.dart';
// Importa un widget para mostrar el detalle del personaje favorito

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  Future<List<Character>> _getFavoriteCharacters() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    List<dynamic> favorites = userDoc.get('favorites');

    List<Character> favoriteCharacters = [];
    for (var characterId in favorites) {
      DocumentSnapshot characterDoc = await FirebaseFirestore.instance
          .collection('characters') // Assume you have a 'characters' collection
          .doc(characterId)
          .get();
      if (characterDoc.exists) {
        Character character = Character.fromDocument(characterDoc);
        favoriteCharacters.add(character);
      }
    }

    return favoriteCharacters;
  }
  return [];
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Character>>(
        future: _getFavoriteCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading favorites'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites found'));
          } else {
            List<Character> favoriteCharacters = snapshot.data!;
            // Impresión de la cantidad de personajes favoritos
            print(
                'Number of favorite characters: ${favoriteCharacters.length}');
            return ListView.builder(
              itemCount: favoriteCharacters.length,
              itemBuilder: (context, index) {
                Character character = favoriteCharacters[index];
                return CharacterCard(
                    character:
                        character); // Display the character using a custom widget
              },
            );
          }
        },
      ),
    );
  }
}
