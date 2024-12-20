import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlyerFormPage extends StatefulWidget {
  const FlyerFormPage({super.key});

  @override
  _FlyerFormPageState createState() => _FlyerFormPageState();
}

class _FlyerFormPageState extends State<FlyerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(); // Nouveau champ pour la description

  // Soumission du flyer
  void _submitFlyer() async {
    if (_formKey.currentState!.validate()) {
      print("Formulaire validé, soumission en cours...");

      final flyer = {
        'imageUrl': _imageUrlController.text,
        'description': _descriptionController.text, // Ajouter la description
        'timestamp': FieldValue.serverTimestamp(), // Ajouter un timestamp
      };

      try {
        // Ajout du flyer à Firestore
        print("Ajout du flyer à Firestore...");
        await FirebaseFirestore.instance.collection('haitiNews').add(flyer);
        print("Flyer ajouté à Firestore : ${flyer['imageUrl']}");

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flyer ajouté avec succès !')),
        );

        Navigator.pop(context); // Retourner à la page précédente
      } catch (e) {
        // Gérer les erreurs lors de l'ajout dans Firestore
        print("Erreur lors de l'ajout du flyer : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } else {
      print("Formulaire non valide.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Publier un flyer"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Ajout pour éviter les dépassements d'écran
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champ pour l'URL de l'image
                const Text("Entrez l'URL de l'image du flyer :"),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: "URL de l'image",
                    hintText: "Exemple: https://exemple.com/image.png",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer l'URL de l'image.";
                    }
                    if (!Uri.parse(value).isAbsolute) {
                      return "URL invalide.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Nouveau champ pour la description
                const Text("Entrez une description pour le flyer :"),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    hintText: "Entrez une description libre...",
                  ),
                  maxLines: 4, // Permet d'écrire plusieurs lignes
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer une description.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Bouton de soumission
                ElevatedButton(
                  onPressed: _submitFlyer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Couleur du bouton
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  ),
                  child: const Text(
                    "Publier le flyer",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
