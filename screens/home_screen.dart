import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'become_seller_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSeller = false; // Par défaut, l'utilisateur n'est pas un vendeur
  int _currentIndex = 0; // Index pour suivre la navigation entre les pages

  // Liste des écrans associés à chaque onglet
  final List<Widget> _screens = [
    HomePage(), // Page d'accueil
    FavoritesPage(), // Page des favoris
    OrdersPage(), // Page des commandes
    ProfilePage(), // Page du profil utilisateur
  ];

  @override
  void initState() {
    super.initState();
    _checkIfUserIsSeller(); // Vérifier si l'utilisateur est un vendeur
  }

  // Vérifier si l'utilisateur est un vendeur dans Firestore
  Future<void> _checkIfUserIsSeller() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        isSeller = userDoc['isSeller'] ?? false;  // Si 'isSeller' est true, l'utilisateur est un vendeur.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Affiche l'écran correspondant à l'index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Indique l'onglet actif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Met à jour l'onglet actif
          });
        },
        type: BottomNavigationBarType.fixed, // Onglets fixes
        selectedItemColor: Colors.orange, // Couleur de l'onglet actif
        unselectedItemColor: Colors.grey, // Couleur des onglets inactifs
        backgroundColor: Colors.black, // Couleur de fond
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ), // Style du texte sélectionné
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ), // Style du texte non sélectionné
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icône maison
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Icône cœur
            label: 'Mes Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), // Icône panier
            label: 'Commandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icône profil
            label: 'Mon Marché',
          ),
        ],
      ),
    );
  }
}

// Page d'accueil
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de navigation supérieure
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            color: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Produits",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Explorer par région",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher vos produits",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),

          // Boutons principaux
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text("Catégories"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text("Produits spéciaux"),
                ),
              ],
            ),
          ),

          // Afficher le bouton "Passer en mode vendeur" si l'utilisateur n'est pas déjà un vendeur
          if (!isSeller) 
            ElevatedButton(
              onPressed: () {
                // Logique pour passer en mode vendeur (Rediriger vers une page ou mettre à jour Firestore)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BecomeSellerPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              child: const Text("Passer en mode Vendeur"),
            ),

          // Section des catégories
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Catégories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              _buildCategory("Électroniques"),
              _buildCategory("Mode"),
              _buildCategory("Alimentation"),
              _buildCategory("Actualités en Haïti"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        child: ListTile(
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
      ),
    );
  }
}

// Page des favoris
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Page des favoris"),
    );
  }
}

// Page des commandes
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Page des commandes"),
    );
  }
}
