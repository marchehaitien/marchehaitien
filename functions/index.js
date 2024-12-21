const functions = require("firebase-functions");
const admin = require("firebase-admin");
const Twilio = require("twilio"); // Utiliser une majuscule pour le constructeur

// Initialisation Firebase
admin.initializeApp();

// Utilisation de variables d'environnement pour les secrets
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = new Twilio(accountSid, authToken);

exports.notifySeller = functions.firestore
    .document("sellerRequests/{requestId}")
    .onUpdate((change, context) => {
      const newValue = change.after.data();
      const status = newValue.status;
      const whatsappNumber = newValue.whatsapp;

      let message = "";
      if (status === "approved") {
        message =
        "Votre demande de vendeur a été acceptée. Bienvenue sur Marché Haïtien !";
      } else if (status === "rejected") {
        message =
        "Votre demande de vendeur a été refusée. Veuillez vérifier vos informations et réessayer.";
      }

      return client.messages.create({
        body: message,
        from: "whatsapp:+14155238886", 
        // Numéro Twilio pour les tests
        to: `whatsapp:${whatsappNumber}`, 
        // Numéro WhatsApp du vendeur
      });
    });
