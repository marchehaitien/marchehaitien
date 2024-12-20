import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final IconData iconData;

  const CategoryCard({super.key, required this.categoryName, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        child: ListTile(
          leading: Icon(iconData, color: Colors.orange),
          title: Text(
            categoryName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Ajouter l'action lors du clic sur la catégorie
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryPage(categoryName: categoryName),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String categoryName;

  const CategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text('Produits de la catégorie $categoryName'),
      ),
    );
  }
}
