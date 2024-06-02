import 'package:flutter/material.dart';
import 'package:spoty_try5/models/character_model.dart';
import 'package:spoty_try5/widgets/zwidgets.dart';

class CharacterScreen extends StatefulWidget {
  final Character character;
  const CharacterScreen({super.key, required this.character});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  bool isFaorite = false;

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
              isFaorite ? Icons.favorite : Icons.favorite_border,
              color: isFaorite ? Colors.pink[300] : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFaorite = !isFaorite;
              });
            },
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
}
