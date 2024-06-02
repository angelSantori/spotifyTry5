import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spoty_try5/models/character_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Character>> _favoriteCharactersFuture;

  @override
  void initState() {
    super.initState();
    _favoriteCharactersFuture = _getFavoriteCharacters();
  }

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
            .collection('characters')
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
        future: _favoriteCharactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading favorites'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites found'));
          } else {
            List<Character> favoriteCharacters = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteCharacters.length,
              itemBuilder: (context, index) {
                Character character = favoriteCharacters[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(character
                        .image!), // Aquí se carga la imagen desde la URL
                  ),
                  title: Text(character.name!),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _removeFavorite(context, character);
                    },
                  ),                  
                );
              },
            );
          }
        },
      ),
    );
  }

  void _removeFavorite(BuildContext context, Character character) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'favorites': FieldValue.arrayRemove([character.id.toString()])
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${character.name} removed from favorites'),
        ),
      );
      // Actualizar la lista de personajes favoritos después de eliminar uno
      setState(() {
        _favoriteCharactersFuture = _getFavoriteCharacters();
      });
    }
  }
}
