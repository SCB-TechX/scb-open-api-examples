Balloon Shop Backend
====================
Example project for partner backend service connected to [SCB Open API](https://developer.scb/). 
Using [NodeJs](https://nodejs.org/) with some widely used libraries. API server with [ExpressJs](https://expressjs.com/), JWT authentication with [PassportJs](https://www.passportjs.org/). And [MongoDB](https://www.mongodb.com/) as the database layer.

Getting started
---------------
To make it easy for you to get started, here's a list of recommended setup steps.
1. Sign up SCB Open API developer account [here](https://developer.scb/).
2. Setup your MongoDB server.
3. Setup environment variables (`.env` file)
```
PORT=
SERVER_JWT_SECRET=MySecret
SCB_API_KEY=l7eb0fcb0350e84308a610bc7a9b6437c0
SCB_API_SECRET=45a90fee5d9443d4971e8566743f720a
SCB_API_ENDPOINT=https://api-sandbox.partners.scb/partners/sandbox
SCB_BILLER_ID=675010384785812
SCB_BILLER_REF3_PREFIX=Biller Prefix
SCB_MERCHANT_ID=Merchant ID from
SCB_MERCHANT_TERMINAL_ID= Merchant terminal ID from 
DB_CONNECTION_URI= MongoDB connection URI
```
4. Start development server `npm start`

Deployment 
----------
Before integrate with the frontend application and the SCB server (webhooks for payment confirmation callback) you have to run the service with public HTTPS endpoint, here're some easy ways to do it.
- [ngrok](https://ngrok.com/) - Exposing your local server to a public URL. 
- [Heroku](https://heroku.com/) -  Cloud platform service.

Contributing
------------
- API Documents
- Unit tests
- Structuring projects