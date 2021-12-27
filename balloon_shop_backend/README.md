# Balloon Shop Backend
This is an example project of partner backend service connected to [SCB Open API](https://developer.scb/). 
Using [NodeJs](https://nodejs.org/) with some widely used libraries, the API server with [ExpressJs](https://expressjs.com/), JWT authentication with [PassportJs](https://www.passportjs.org/). And [MongoDB](https://www.mongodb.com/) as the database layer.

---

## 1. Getting started
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
4. Install dependency `npm install`
5. Start development server `npm start`

---

## Documentation
We provide service information such as API specification and the data collections detail to make you learn the service faster.

### Collections
As mention above this project use [MongoDB](https://www.mongodb.com/). Here's the collections description.

#### users
```javascript
{
    "_id" : ObjectId,
    "email" : String,
    "password" : String
}
```

#### products
```javascript
{
    "_id" : ObjectId,
    "imageUrl" : String,
    "name" : String,
    "price" : Double
}
```

#### transactions
```javascript
{
    "_id" : ObjectId,
    "transactionStatus" : String,
    "transactionRef" : String,
    "qrId" : String,
    "paymentMethod" : String
}
```

---

### API specification

#### Create Login Token
```http
POST /token
```
##### Request 
###### Header
| Key            | Value                          |
| :------------- | :----------------------------- |
| `Content-Type` | **Required**. application/json |
###### Body
| Parameter  | Type     | Description                          |
| :--------- | :------- | :----------------------------------- |
| `email`    | `string` | **Required**. Email of login user    |
| `password` | `string` | **Required**. Password of login user |

##### Response 
###### Header
| Key            | Value            |
| :------------- | :--------------- |
| `Content-Type` | application/json |
###### Body
| Parameter     | Type     | Description                     |
| :------------ | :------- | :------------------------------ |
| `accessToken` | `string` | JWT Token for access secure API |
###### Return Code
| Status Code | Return Code | Description               |
| :---------- | :---------- | :------------------------ |
| `401`       | `40101`     | invalid email or password |
| `500 `      | `50001`     | internal server error     |
| `500 `      | `50002`     | fail to request scb token |

---

#### Get Products
```http
GET /products
```
##### Request 
###### Header
| Key             | Value                              |
| :-------------- | :--------------------------------- |
| `Content-Type`  | **Required**. application/json     |
| `Authorization` | **Required**. Bearer `accessToken` |

##### Response 
###### Header
| Key            | Value            |
| :------------- | :--------------- |
| `Content-Type` | application/json |
###### Body
| Parameter  | Type    | Description                              |
| :--------- | :------ | :--------------------------------------- |
| `products` | `Array` | List of items in the products collection |
###### Return Code
| Status Code | Return Code | Description           |
| :---------- | :---------- | :-------------------- |
| `401`       | `40102`     | invalid token         |
| `500 `      | `50001`     | internal server error |

---

#### Payment Confirmation Callback
```http
POST /payment/confirmation
```
##### Request 
###### Header
| Key            | Value                          |
| :------------- | :----------------------------- |
| `Content-Type` | **Required**. application/json |
###### Body
| Parameter         | Type     | Description                                                                      |
| :---------------- | :------- | :------------------------------------------------------------------------------- |
| `billPaymentRef1` | `string` | **Required**. For reference with `transactionRef` in the transactions collection |
##### Response 
###### Header
| Key            | Value            |
| :------------- | :--------------- |
| `Content-Type` | application/json |
###### Body
| Parameter           | Type     | Description                                             |
| :------------------ | :------- | :------------------------------------------------------ |
| `_id`               | `string` | Transaction identifier                                  |
| `transactionStatus` | `string` | Transaction status                                      |
| `transactionRef`    | `string` | Transaction reference matching with `billPaymentRef1`   |
| `qrId`              | `string` | Transaction QR code identifier                          |
| `paymentMethod`     | `string` | Transaction payment use case. Can be `qr` or `deeplink` |
###### Return Code
| Status Code | Return Code | Description           |
| :---------- | :---------- | :-------------------- |
| `401`       | `40102`     | invalid token         |
| `500 `      | `50001`     | internal server error |

---

#### Generate Payment Deeplink
```http
POST /payment/deeplink
```
##### Request 
###### Header
| Key             | Value                              |
| :-------------- | :--------------------------------- |
| `Content-Type`  | **Required**. application/json     |
| `Authorization` | **Required**. Bearer `accessToken` |
###### Body
| Parameter                   | Type     | Description                                                    |
| :-------------------------- | :------- | :------------------------------------------------------------- |
| `orderedProducts`           | `array`  | **Required**. List of ordered product for create a transaction |
| `orderedProducts[n]._id`    | `string` | **Required**. Product identifier                               |
| `orderedProducts[n].amount` | `string` | **Required**. Product amount for calculate total price         |
##### Response 
###### Header
| Key            | Value            |
| :------------- | :--------------- |
| `Content-Type` | application/json |
###### Body
| Parameter       | Type     | Description                           |
| :-------------- | :------- | :------------------------------------ |
| `transactionId` | `string` | Transaction identifier                |
| `deeplinkUrl`   | `string` | Deeplink to open SCB Easy Application |
| `userRefId`     | `string` | User identifier                       |
###### Return Code
| Status Code | Return Code | Description           |
| :---------- | :---------- | :-------------------- |
| `401`       | `40102`     | invalid token         |
| `500 `      | `50001`     | internal server error |

---

#### Generate Payment QR Code
```http
POST /payment/qr
```
##### Request 
###### Header
| Key             | Value                              |
| :-------------- | :--------------------------------- |
| `Content-Type`  | **Required**. application/json     |
| `Authorization` | **Required**. Bearer `accessToken` |
###### Body
| Parameter                   | Type     | Description                                                    |
| :-------------------------- | :------- | :------------------------------------------------------------- |
| `orderedProducts`           | `array`  | **Required**. List of ordered product for create a transaction |
| `orderedProducts[n]._id`    | `string` | **Required**. Product identifier                               |
| `orderedProducts[n].amount` | `string` | **Required**. Product amount for calculate total price         |
##### Response 
###### Header
| Key            | Value            |
| :------------- | :--------------- |
| `Content-Type` | application/json |
###### Body
| Parameter  | Type     | Description                                                      |
| :--------- | :------- | :--------------------------------------------------------------- |
| `qrImage`  | `string` | QR code image for scan with banking application in base64 encode |
| `qrcodeId` | `string` | Transaction QR code identifier                                   |
###### Return Code
| Status Code | Return Code | Description           |
| :---------- | :---------- | :-------------------- |
| `401`       | `40102`     | invalid token         |
| `500 `      | `50001`     | internal server error |

---

#### Get Payment QR Code Status
```http
GET /payment/qr/status
```
##### Request 
###### Header
| Key             | Value                              |
| :-------------- | :--------------------------------- |
| `Authorization` | **Required**. Bearer `accessToken` |
###### Query
| Parameter | Type     | Description                                  |
| :-------- | :------- | :------------------------------------------- |
| `qrId`    | `string` | **Required**. Transaction QR code identifier |
##### Response 
###### Header
| Key            | Value            |
| :------------- | :--------------- |
| `Content-Type` | application/json |
###### Body
| Parameter           | Type     | Description                                             |
| :------------------ | :------- | :------------------------------------------------------ |
| `_id`               | `string` | Transaction identifier                                  |
| `transactionStatus` | `string` | Transaction status                                      |
| `transactionRef`    | `string` | Transaction reference matching with `billPaymentRef1`   |
| `qrId`              | `string` | Transaction QR code identifier                          |
| `paymentMethod`     | `string` | Transaction payment use case. Can be `qr` or `deeplink` |
###### Return Code
| Status Code | Return Code | Description           |
| :---------- | :---------- | :-------------------- |
| `401`       | `40102`     | invalid token         |
| `500 `      | `50001`     | internal server error |

---

## Deployment 
Before integrate with the frontend application and the SCB server (webhooks for payment confirmation callback) you have to run the service with public HTTPS endpoint, here're some easy ways to do it.
- [ngrok](https://ngrok.com/) - Exposing your local server to a public URL. 
- [Heroku](https://heroku.com/) -  Cloud platform service.

---

## Contributing
- API Documents
- Unit tests
- Structuring projects
- Login security