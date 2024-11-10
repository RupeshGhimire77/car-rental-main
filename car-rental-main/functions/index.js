const functions = require("firebase-functions");
const stripeSecretKey =
"sk_test_51QJTT8EAjiwNTNnlDdUqF7qBxF9UPdGTrHhWF9HgPNG8Qxkj54PtxM48b"+
"f3yUPqVqAXWOzFtnSMGnKGHVPhcNVdG00pOxXk7Qs";
// Replace with your actual secret key
const stripe = require("stripe")(stripeSecretKey);

exports.stripePaymentIntentRequest =
functions.https.onRequest(async (req, res) => {
  try {
    // Ensure the request is a POST request and has the required body parameters
    if (req.method !== "POST") {
      return res.status(405).send({success: false, error:
        "Method Not Allowed"});
    }

    const {email, amount} = req.body;

    // Validate input
    if (!email || !amount) {
      return res.status(400).send({success: false, error:
         "Email and amount are required."});
    }

    let customerId;

    // Get the customer whose email matches the one sent by the client
    const customerList = await stripe.customers.list({
      email: email,
      limit: 1,
    });

    // Check if the customer exists; if not, create a new customer
    if (customerList.data.length !== 0) {
      customerId = customerList.data[0].id;
    } else {
      const customer = await stripe.customers.create({
        email: email,
      });
      customerId = customer.id; // Use customer.id instead of customer.data.id
    }

    // Create a temporary secret key linked with the customer
    const ephemeralKey = await stripe.ephemeralKeys.create(
        {customer: customerId},
        {apiVersion: "2020-08-27"},
    );

    // Create a new payment intent with the amount passed in from the client
    const paymentIntent = await stripe.paymentIntents.create({
      amount: parseInt(amount), // Ensure amount is an integer
      currency: "usd",
      customer: customerId,
    });

    // Respond with the client secret, ephemeral key, and customer ID
    res.status(200).send({
      paymentIntent: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      customer: customerId,
      success: true,
    });
  } catch (error) {
    console.error("Error creating payment intent:", error);
    // Log the error for debugging
    res.status(500).send({success: false, error: error.message});
  }
});
