// ============================
// HPay Stripe Server (Node.js)
// ============================

const express = require('express');
const cors = require('cors');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
// ← your secret key
);

const app = express();

// ✅ Middleware
app.use(cors());
app.use((req, res, next) => {
  if (req.path === '/webhook') return next(); // raw for webhooks
  express.json()(req, res, next);
});

// ============================
// 1️⃣ Create a Payment Sheet
// ============================
app.post('/prepare-payment-sheet', async (req, res) => {
  try {
    console.log('🛰️ Preparing new payment sheet...');

    // Create a Customer for this session
    const customer = await stripe.customers.create();

    // Create an Ephemeral Key (for mobile use)
    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customer.id },
      { apiVersion: '2024-04-10' }
    );

    // Create a placeholder PaymentIntent (amount updated later)
    const paymentIntent = await stripe.paymentIntents.create({
      amount: 200, // 2 SAR placeholder
      currency: 'usd', // stripe doesn't accept sar so logic USD but ui SAR
      customer: customer.id,
      automatic_payment_methods: { enabled: true },
    });

    console.log('✅ Created PaymentIntent:', paymentIntent.id);

    // Respond with all info needed for iOS
    res.json({
      customer: customer.id,
      ephemeralKey: ephemeralKey.secret,
      clientSecret: paymentIntent.client_secret,
      paymentIntentID: paymentIntent.id,
      publishableKey:
        'pk_test_51SNhF3FUM6KSz0vmedIsNU42iFUaLhNy2izBtAdq50cg7Di0liBGsSNUHlh6YI7gk88Xk5OacSeTgpApyYxCvP6C00YE78Wwp5',
    });
  } catch (err) {
    console.error('❌ Error in /prepare-payment-sheet:', err.message);
    res.status(500).json({ error: err.message });
  }
});

// ============================
// 2️⃣ Update Payment Amount
// ============================
app.post('/update-payment-sheet', express.json(), async (req, res) => {
  try {
    const { paymentIntentID, amount } = req.body;
    console.log(`🛰️ Updating PaymentIntent ${paymentIntentID} → amount: ${amount}`);

    if (!paymentIntentID || !amount) {
      return res.status(400).json({ error: 'Missing paymentIntentID or amount.' });
    }

    const updatedIntent = await stripe.paymentIntents.update(paymentIntentID, {
      amount: parseInt(amount),
    });

    console.log('✅ PaymentIntent updated:', updatedIntent.id, '→', updatedIntent.amount);
    res.json({ ok: true });
  } catch (err) {
    console.error('❌ Error in /update-payment-sheet:', err.message);
    res.status(500).json({ error: err.message });
  }
});

// ============================
// 3️⃣ Stripe Webhook (optional)
// ============================
app.post('/webhook', express.raw({ type: 'application/json' }), (req, res) => {
  const event = req.body;
  console.log(`📩 Webhook event: ${event.type}`);

  switch (event.type) {
    case 'payment_intent.succeeded':
      console.log('✅ Payment succeeded:', event.data.object.id);
      break;
    case 'payment_intent.payment_failed':
      console.log('❌ Payment failed:', event.data.object.id);
      break;
    default:
      console.log('ℹ️ Unhandled event:', event.type);
  }

  res.status(200).send();
});

// ============================
// 🚀 Start the Server
// ============================
const PORT = 4242;
app.listen(PORT, () =>
  console.log(`✅ Server running on http://localhost:${PORT}`)
);
