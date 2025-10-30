 # 💳 HPay — Snbla Challenge  

A lightweight iOS wallet app inspired by **HungerStation’s HPay** experience.  
Built with **SwiftUI** and **Stripe PaymentSheet**, the app allows users to:

- 💰 **Top up their wallet** using Stripe test payments  
- 💳 **Add and view saved cards** with validation  
- 📜 **View recent transactions** in a clean, rounded interface  
## 📱 HPay - DEMO

<p align="center">


[![Watch the demo on YouTube](https://img.youtube.com/vi/mt5v1YNgEKo/maxresdefault.jpg)](https://youtube.com/shorts/mt5v1YNgEKo)
</p>



## 🧰 Tech Stack  

| Layer | Technology |
|-------|-------------|
| **Frontend** | SwiftUI, Combine |
| **Backend** | Node.js, Express |
| **Payments** | Stripe PaymentSheet SDK |
| **IDE / Tools** | Xcode 16.3, iOS 18.4 SDK |
| **Version Control** | Git & GitHub |

---

## ⚙️  Setup Instructions  

### 1️⃣  Clone the Repository  
```bash
git clone https://github.com/YourUsername/HPay_Snbla_Assessment.git
cd HPay_Snbla_Assessment
```
### 2️⃣  Backend Setup (Stripe Mock Server)

To simulate payments, a lightweight Node.js + Express backend is included for local testing.
```bash
cd HPayServer
```



Open server.js and replace the placeholder Stripe keys with your own test keys from your Stripe Dashboard
.

Install dependencies and start the server:
```bash
npm install
node server.js
```

Once running successfully, you should see:
```bash
✅ Server running on http://localhost:4242
```
### 3️⃣  iOS App Setup

1. Open the project file in Xcode:

2. open HPay.xcodeproj


3. Make sure StripePaymentSheet is added via Swift Package Manager.

4. Run the app on an iOS 18+ simulator.

4. Test the flow:

5. Tap Top-up → Select an amount → Tap Continue to launch Stripe’s PaymentSheet.

6. Use Stripe’s test card:

4242 4242 4242 4242  
Any future expiration date  
Any 3-digit CVC  


7. Complete the mock payment — the wallet balance updates automatically, and the transaction appears in the list.

## 💡 Assumptions & Limitations

- 🧩 Stripe integration runs in test mode only (no real payments processed).

- 💾 Wallet balance, cards, and transactions are stored locally (in-memory).

- 📶 Backend runs only on localhost (not deployed).

- 🧪 Transactions and Cards are mock data for demonstration purposes.

## 🚀 Future Improvements

If given more time, I would:

- 💳 Extend Stripe integration to handle real saved cards and payment history.
  
- ☁️ Integrate CloudKit or Firebase for persistent, real-time storage.

- 🔐 Add secure storage for saved cards using Keychain or encrypted CoreData.

- ⚡️ Improve error handling for smoother UX.

- 🧠 Implement unit tests and UI tests to ensure stability.

- 🎨 Change the placement of add new Card Text Fields and seperated it into a new UI
