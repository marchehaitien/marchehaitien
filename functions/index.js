const functions = require('firebase-functions');
const admin = require('firebase-admin');
const twilio = require('twilio');

// Initialisation Firebase (gardez votre code existant ici)
admin.initializeApp();


/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


const accountSid = 'AC06ed06a1ab78b36d445bc2f82f261421'; // Remplacez par votre SID Twilio
const authToken = '2eddbe871fde4dd359d74ad287175fb9'; // Remplacez par votre token Twilio
const client = new twilio(accountSid, authToken);

exports.notifySeller = functions.firestore
  .document('sellerRequests/{requestId}')
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const status = newValue.status;
    const whatsappNumber = newValue.whatsapp;

    let message = '';
    if (status === 'approved') {
      message = 'Votre demande de vendeur a été acceptée. Bienvenue sur Marché Haïtien !';
    } else if (status === 'rejected') {
      message = 'Votre demande de vendeur a été refusée. Veuillez vérifier vos informations et réessayer.';
    }

    return client.messages.create({
      body: message,
      from: 'whatsapp:+14155238886', // Numéro Twilio pour les tests
      to: `whatsapp:${whatsappNumber}` // Numéro WhatsApp du vendeur
    });
  });
