import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firestore cloud
Future<void> createUserDocument(User user) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Crea un documento para el usuario con su UID
  await firestore.collection('users').doc(user.uid).set({
    'favorites': [],  // Inicialmente, no hay favoritos
  });
}

// Agregar y eliminar favoritos
Future<void> toggleFavorite(String characterId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  DocumentReference userDoc = firestore.collection('users').doc(user.uid);

  DocumentSnapshot doc = await userDoc.get();
  List<dynamic> favorites = doc.get('favorites');

  if (favorites.contains(characterId)) {
    // Eliminar de favoritos
    userDoc.update({
      'favorites': FieldValue.arrayRemove([characterId])
    });
  } else {
    // Agregar a favoritos
    userDoc.update({
      'favorites': FieldValue.arrayUnion([characterId])
    });
  }
}
