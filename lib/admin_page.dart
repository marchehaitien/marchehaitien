import 'product_form_page.dart';
import 'flyer_form_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demandes des vendeurs'),
        backgroundColor: Colors.orange,
        actions: [
          // Bouton pour ajouter un produit
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductFormPage()),
              );
            },
          ),
          // Bouton pour ajouter un flyer
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FlyerFormPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sellerRequests')
            .where('status', isEqualTo: 'pending')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucune demande trouvée.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
                title: Text(request['businessName'] ?? 'Nom non disponible'),
                subtitle: Text('WhatsApp: ${request['whatsapp']}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showSellerDetails(context, request),
              );
            },
          );
        },
      ),
    );
  }

void _showSellerDetails(BuildContext context, DocumentSnapshot request) {
  FocusScope.of(context).unfocus(); // Enlève le focus actuel avant d'ouvrir le dialogue
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(request['businessName'] ?? 'Nom non disponible'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Numéro WhatsApp: ${request['whatsapp']}'),
              Text('Natcash: ${request['natcash'] ?? 'Non fourni'}'),
              Text('Moncash: ${request['moncash'] ?? 'Non fourni'}'),
              Text('Catégories: ${request['categories'].join(', ')}'),
              Text('Lieux de livraison: ${request['deliveryLocations'].join(', ')}'),
            ],
          ),
        ),
          actions: [
            TextButton(
              onPressed: () {
                _updateSellerRequestStatus(request.id, 'approved');
                _sendWhatsAppMessage(
                  context,
                  request['whatsapp'],
                  'Votre demande a été acceptée. Bienvenue comme vendeur sur notre plateforme !',
                );
                Navigator.pop(context);
              },
              child: const Text('Accepter', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                _updateSellerRequestStatus(request.id, 'rejected');
                _sendWhatsAppMessage(
                  context,
                  request['whatsapp'],
                  'Votre demande a été refusée. Veuillez contacter l\'administration pour plus de détails.',
                );
                Navigator.pop(context);
              },
              child: const Text('Refuser', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _updateSellerRequestStatus(String requestId, String status) async {
    await FirebaseFirestore.instance
        .collection('sellerRequests')
        .doc(requestId)
        .update({'status': status});

    _sendNotification(requestId, status);
  }

  void _sendNotification(String requestId, String status) {
    String message = status == 'approved'
        ? 'Votre demande de vendeur a été acceptée.'
        : 'Votre demande de vendeur a été refusée.';

    FirebaseFirestore.instance.collection('notifications').add({
      'userId': requestId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification envoyée: $message')),
      );
    }
  }

  void _sendWhatsAppMessage(BuildContext context, String phoneNumber, String message) async {
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp')),
      );
    }
  }
}
