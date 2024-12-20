import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Électroniques',
    'Mode',
    'Alimentation',
  ];

  // Fonction pour soumettre le formulaire
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final product = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text),
        'category': _selectedCategory,
        'imageUrl': _imageUrlController.text,
      };

      // Ajouter le produit à Firestore
      await FirebaseFirestore.instance.collection('products').add(product);

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produit ajouté avec succès!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un produit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Champ pour le nom du produit
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom du produit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de produit';
                  }
                  return null;
                },
              ),
              
              // Champ pour la description du produit
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              
              // Sélecteur de catégorie
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text("Choisissez une catégorie"),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              
              // Champ pour le prix en gourdes
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Prix (en gourdes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un prix valide';
                  }
                  return null;
                },
              ),
              
              // Champ pour l'URL de l'image
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'URL de l\'image';
                  }
                  return null;
                },
              ),

              // Bouton pour soumettre le formulaire
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Soumettre'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
