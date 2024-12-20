import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pour gérer la sélection de l'image
import 'dart:io';
import '../edit_profile_page.dart'; // Importation du fichier EditProfilePage
import '../become_seller_page.dart'; // Importation du fichier BecomeSellerPage

class ProfilePage extends StatefulWidget {
  final bool isDarkMode; // Paramètre pour savoir si le mode sombre est activé
  final VoidCallback toggleTheme; // Paramètre pour changer le thème

  // Constructeur qui accepte ces paramètres
  const ProfilePage(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage; // Stocke l'image sélectionnée

  // Fonction pour sélectionner une image depuis la galerie
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          // Icône pour basculer entre mode sombre et clair
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget
                .toggleTheme, // Changez le mode quand on appuie sur l'icône
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affiche l'image de profil (par défaut si aucune image n'est sélectionnée)
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/default_user.jpeg')
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            // Bouton pour modifier le profil
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()),
                );
              },
              child: const Text('Modifier le profil'),
            ),
            // Bouton pour devenir vendeur
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BecomeSellerPage()),
                );
              },
              child: const Text('Devenir Vendeur'),
            ),
          ],
        ),
      ),
    );
  }
}
