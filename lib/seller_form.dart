import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerFormPage extends StatefulWidget {
  const SellerFormPage({super.key});

  @override
  _SellerFormPageState createState() => _SellerFormPageState();
}

class _SellerFormPageState extends State<SellerFormPage> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _natcashController = TextEditingController();
  final TextEditingController _moncashController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _citySearchController = TextEditingController();

  final List<String> _selectedCategories = [];
  final List<String> _selectedCities = [];
  List<String> _filteredCities = [];

  final List<String> _categories = [
    'Électronique',
    'Mode',
    'Alimentation',
    'Produits spéciaux',
  ];

  final List<String> _cities = [
    'Port-au-Prince', 'Carrefour', 'Delmas', 'Pétion-ville', 'Gonaïves',
    'Cité Soleil', 'Cap-Haïtien', 'Saint Marc', 'Croix-des-Bouquets',
    'Petit-Goâve', 'Léogâne', 'Port-de-Paix', 'Tabarre', 'Les Cayes',
    'Ouanaminthe', 'Cabaret', 'Limbé', 'Anse-à-Galets', 'Jacmel',
    'Grand-Goâve', 'Petite-Rivière-de-l\'Artibonite', 'Jérémie', 'Hinche',
    'Gros-Morne', 'Saint-Michel-de-l\'Attalaye', 'Saint-Louis-du-Nord',
    'Desdunes', 'Dessalines', 'Trou-du-Nord', 'Arcahaie', 'Kenscoff',
    'L\'Estère', 'Fort-Liberté', 'Gressier', 'Limonade', 'Plaisance',
    'Fonds-Verrettes', 'Mirebalais', 'Thomazeau', 'Grande Rivière du Nord',
    'Saint-Raphaël', 'Verrettes', 'Pignon', 'Terrier-Rouge', 'Port-Margot',
    'Thomassique', 'Anse-d\'Ainault', 'Maïssade', 'Miragoâne', 'Belladère',
    'Ganthier', 'Dondon', 'Jean-Rabel', 'Thomonde', 'Plaine-du-Nord',
    'Dame-Marie', 'Acul-du-Nord', 'Lascahobas'
  ];

  final bool _selectAllCities = false;

  @override
  void initState() {
    super.initState();
    _filteredCities = List.from(_cities);
    _citySearchController.addListener(_filterCities);
  }

  void _filterCities() {
    setState(() {
      _filteredCities = _cities
          .where((city) => city.toLowerCase().contains(_citySearchController.text.toLowerCase()))
          .toList();
    });
  }

  void _submitForm() async {
    if (_businessNameController.text.isEmpty ||
        _whatsappController.text.isEmpty ||
        (_natcashController.text.isEmpty && _moncashController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs requis.')),
      );
      return;
    }

    final formData = {
      'businessName': _businessNameController.text,
      'natcash': _natcashController.text,
      'moncash': _moncashController.text,
      'whatsapp': _whatsappController.text,
      'categories': _selectedCategories,
      'deliveryLocations': _selectedCities,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('sellerRequests').add(formData);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Vous serez contacté avec le numéro WhatsApp fourni.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Passer en mode vendeur'),
      backgroundColor: Colors.orange,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _businessNameController,
              decoration: const InputDecoration(labelText: 'Nom de l\'entreprise'),
            ),
            const SizedBox(height: 20),
            _buildPaymentSection(),
            _buildCategorySection(),
            const SizedBox(height: 20),
            _buildDeliverySection(), // Ajout de la section des lieux de livraison
            _buildWhatsappSection(), // Ajout de la section WhatsApp
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Envoyer le formulaire'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Moyen de paiement',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        CheckboxListTile(
          title: const Text('Numéro Natcash'),
          value: _natcashController.text.isNotEmpty,
          onChanged: (value) {
            if (value == true) {
              _showInputDialog('Numéro Natcash', _natcashController);
            } else {
              _natcashController.clear();
            }
            setState(() {});
          },
        ),
        CheckboxListTile(
          title: const Text('Numéro Moncash'),
          value: _moncashController.text.isNotEmpty,
          onChanged: (value) {
            if (value == true) {
              _showInputDialog('Numéro Moncash', _moncashController);
            } else {
              _moncashController.clear();
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catégories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ..._categories.map((category) => CheckboxListTile(
              title: Text(category),
              value: _selectedCategories.contains(category),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            )),
      ],
    );
  }

    Widget _buildDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre pour les lieux de livraison
        const Text(
          'Lieux de vos livraisons',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _citySearchController,
          decoration: const InputDecoration(
            labelText: 'Rechercher une ville',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        ..._filteredCities.map((city) => CheckboxListTile(
              title: Text(city),
              value: _selectedCities.contains(city),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedCities.add(city);
                  } else {
                    _selectedCities.remove(city);
                  }
                });
              },
            )),
      ],
    );
  }

  Widget _buildWhatsappSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre pour le numéro WhatsApp
        const Text(
          'Veuillez saisir votre numéro WhatsApp pour vous contacter',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _whatsappController,
          decoration: const InputDecoration(labelText: 'Numéro WhatsApp'),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 30),
      ],
    );
  }


 void _showInputDialog(String title, TextEditingController controller) {
  TextEditingController tempController = TextEditingController(text: controller.text);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: tempController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: 'Entrez le numéro'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.text = tempController.text; // Mise à jour du contrôleur principal
              Navigator.pop(context); // Ferme la boîte de dialogue
              setState(() {}); // Met à jour l'état pour refléter les changements
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Ferme la boîte de dialogue sans sauvegarder
            },
            child: const Text('Annuler'),
          ),
        ],
      );
    },
  );
}
}
