import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // Pour la gestion de la photo
import 'dart:io'; // Pour la gestion des fichiers locaux

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

  // Fonction pour prendre une photo ou en choisir une depuis la galerie
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Marché Haïtien"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mes Informations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Photo de profil
            Center(
              child: GestureDetector(
                onTap: _pickImage, // Ouvre l'option pour choisir une image
                child: CircleAvatar(
                  radius: 50,
                 backgroundImage: _profileImage == null
    ? AssetImage('assets/default_user.jpeg') // Image par défaut
    : FileImage(_profileImage!),

                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, color: Colors.white)
                      : null, // Affiche une icône de caméra si pas d'image
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Informations du profil
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.orange),
                title: Text(
                  user?.phoneNumber ?? "Numéro inconnu",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Numéro de téléphone vérifié"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Option : Passer en mode vendeur
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BecomeSellerPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Passer en mode vendeur",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            // Option : Déconnexion
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Se déconnecter",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
