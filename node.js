const functions = require("firebase-functions");
const admin = require('firebase-admin')
const stripe = require('stripe')('key')
admin.initializeApp()

const db = admin.firestore()
const auth = admin.auth()

 exports.createStripeUser = functions.https.onCall(async (data, context) => {
  const email = data.email;
  const uid = context.auth.uid;

  if (uid === null) {
    console.log('Invalid access.')
    throw new functions.https.HttpsError('internal', 'Invalid access');
  }

  return stripe.customers
    .create({ email: email })
    .then((customer) => {
      return customer["id"];
    })
    .then((customerId) => {
      admin.firestore().collection('users').doc(uid).set(
        {
          stripeId: customerId,
          email: email,
          id: uid
        }
      )
      return customerId
    })
    .catch((err) => {
      console.log(err);
      throw new functions.https.HttpsError("internal", "Unable to create Stripe user: " + err);
    });
});

exports.createEphemeralKey = functions.https.onCall(async (data, context) => {
 
  const customerId = data.customerId;
  const apiVersion = data.apiVersion;
  const uid = context.auth.uid;
 
  if (uid === null) {
      console.log('Invalid access while creating ephemeral key.')
      throw new functions.https.HttpsError('internal', 'Invalid access while creating ephemeral key.');
  }
 
  return stripe.ephemeralKeys.create(
    { customer: customerId},
    { apiVersion: apiVersion} 
  ).then((key) => {
    return key
  }).catch( (err) => {
    functions.logger.log('Error creating ephemeral key', err)
    throw new functions.https.HttpsError('internal', 'Error creating ephemeral key: ' + err)
  })
})

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
 
  const total = data.total;
  const idempotency = data.idempotency;
  const customer = data.customer_id;
 
  const uid = context.auth.uid;
 
  if (uid === null) {
      console.log('Invalid access while creating payment intent.')
      throw new functions.https.HttpsError('internal', 'Invalid access while creating payment intent.');
  }
 
  return stripe.paymentIntents
    .create(
      {
        amount: total,
        currency: "usd",
        customer: customer,
        payment_method_types: ['card', 'ach_debit'],
      },
      {
        idempotencyKey: idempotency,
      }
    )
    .then((intent) => {
      return intent.client_secret;
    })
    .catch((err) => {
      console.log("Unable to create Payment Intent");
      throw new functions.https.HttpsError(
        "internal",
        "Unable to create Payment Intent: " + err
      );
    });
});