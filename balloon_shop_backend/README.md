Balloon Shop Backend
====================
This is an example project of partner backend service connected to [SCB Open API](https://developer.scb/). 
Using [NodeJs](https://nodejs.org/) with some widely used libraries, the API server with [ExpressJs](https://expressjs.com/), JWT authentication with [PassportJs](https://www.passportjs.org/). And [MongoDB](https://www.mongodb.com/) as the database layer.

Documentation
-------------
We provide service information documents such as API specification and the data dictionary to make you understand the service faster.
- Data
- API spec / sequence diagram
- postman collection

Getting started
---------------
To make it easy for you to get started, here's a list of recommended setup steps.
1. Sign up SCB Open API developer account [here](https://developer.scb/).
2. Setup your MongoDB server.
3. Setup environment variables (`.env` file)
```
PORT=
SERVER_JWT_SECRET= config your own
SCB_API_KEY= from SCB developer
SCB_API_SECRET= from SCB developer
SCB_API_ENDPOINT=https://api-sandbox.partners.scb/partners/sandbox
SCB_BILLER_ID= from SCB developer
SCB_BILLER_REF3_PREFIX= from SCB developer
SCB_MERCHANT_ID= from SCB developer
SCB_MERCHANT_TERMINAL_ID= from SCB developer
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
- Login security