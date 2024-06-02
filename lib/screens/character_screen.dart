import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spoty_try5/auth/user_model.dart';
import 'package:spoty_try5/models/character_model.dart';
import 'package:spoty_try5/widgets/zwidgets.dart';

class CharacterScreen extends StatefulWidget {
  final Character character;
  const CharacterScreen({super.key, required this.character});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(widget.character.name!),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.pink[300] : Colors.white,
            ),
            onPressed: _toggleCharacterFavorite,
          ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: Hero(
                tag: widget.character.id!,
                child: Image.network(
                  widget.character.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: size.height * 0.14,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cardData("Status: ", widget.character.status!),
                  cardData("Specie: ", widget.character.species!),
                  cardData("Origin: ", widget.character.origin!.name!),
                ],
              ),
            ),
            const Text(
              'Episode',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            EpisodeList(size: size, character: widget.character)
          ],
        ),
      ),
    );
  }

  Widget cardData(String text1, String text2) {
    return Expanded(
        child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(text1),
          Text(
            text2,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> _toggleCharacterFavorite() async {
    await toggleFavorite(widget.character.id.toString());
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _checkIfFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      List<dynamic> favorites = userDoc.get('favorites');
      setState(() {
        isFavorite = favorites.contains(widget.character.id.toString());
      });
    }
  }
}
