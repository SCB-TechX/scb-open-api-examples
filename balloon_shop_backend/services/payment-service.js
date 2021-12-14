const NodeCache = require("node-cache");
const cache = new NodeCache();

const ApiResponseCodes = require('../constants/api-response-codes')
const scbApi = require('../apis/scb-api')
const productService = require('./product-service')
const RandomString = require("randomstring");

const _db = require('../data/db')

const SCB_TOKEN_KEY = 'scb-token';
const TRANSACTIONS_COLLECTION = 'transactions'

const getScbToken = async () => {
    let scbToken = cache.get(SCB_TOKEN_KEY)
    if (!scbToken
        || !scbToken.accessToken
        || !scbToken.expireDate
        || scbToken.expireDate < Date.now()) {

        let tokenResponse = await scbApi.tokenV1()
        let tokenResponseData = tokenResponse.data
        if (!tokenResponseData
            || !tokenResponseData.accessToken
            || !tokenResponseData.expiresAt) {
            throw { responseCode: ApiResponseCodes.REQUEST_SCB_TOKEN_FAIL };
        }
        scbToken = {
            ...tokenResponseData,
            expireDate: new Date(tokenResponseData.expiresAt * 1000)
        }
        cache.set(SCB_TOKEN_KEY, scbToken)
        console.log('scbToken:', scbToken)
    }
    return scbToken;
}

const genarateTransactionReference = () => {
    return RandomString.generate({
        length: 10,
        charset: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    })
}

const calculateTotalPrice = async (productOrders) => {
    let totalPrice = 0.00
    const products = await productService.getProducts()
    productOrders.forEach(productOrder => {
        const product = products.find(product => product._id.toString() === productOrder._id);
        if (product) {
            totalPrice = totalPrice + (product.price * productOrder.amount);
        } else {
            console.log('product', product)
            throw {};
        }
    })
    console.log('totalPrice', totalPrice)
    return totalPrice;
}

module.exports.createDeeplink = async (user, body) => {
    try {
        const scbToken = await getScbToken();
        const { productOrders } = body
        const totalPrice = await calculateTotalPrice(productOrders)
        const transactionRef = genarateTransactionReference()
        const deeplinkResponse = await scbApi.createPaymentDeeplink(scbToken.accessToken, {
            user: user,
            amount: totalPrice,
            transactionRef: transactionRef,
        })
        let deeplinkResponseData = deeplinkResponse.data
        if (!deeplinkResponseData.deeplinkUrl) {
            throw { responseCode: ApiResponseCodes.REQUEST_SCB_CREATE_DEEPLINK_FAIL };
        }
        await _db.instance()
            .collection(TRANSACTIONS_COLLECTION)
            .insertOne({
                transactionId: deeplinkResponseData.transactionId,
                transactionStatus: 'PENDING',
                transactionRef: transactionRef,
                paymentMethod: 'deeplink',
                userRefId: deeplinkResponseData.userRefId,

            })
        return deeplinkResponseData;

    } catch (err) {
        throw err;
    }
}

module.exports.createQr = async (user, body) => {
    try {
        const scbToken = await getScbToken();
        const { productOrders } = body
        const totalPrice = await calculateTotalPrice(productOrders)
        const transactionRef = genarateTransactionReference()
        const qrResponse = await scbApi.createPaymentQr(scbToken.accessToken, {
            user: user,
            amount: totalPrice,
            transactionRef: transactionRef,
        })

        const qrResponseData = qrResponse.data
        await _db.instance()
            .collection(TRANSACTIONS_COLLECTION)
            .insertOne({
                transactionStatus: 'PENDING',
                transactionRef: transactionRef,
                qrId: qrResponseData.qrcodeId,
                paymentMethod: 'qr',
            })
        return qrResponse.data
    } catch (err) {
        throw err;
    }
}

module.exports.paymentConfirmation = async (body) => {
    try {
        const { billPaymentRef1 } = body
        const transaction = await _db.instance()
            .collection(TRANSACTIONS_COLLECTION)
            .findOneAndUpdate(
                {
                    transactionRef: billPaymentRef1
                },
                {
                    $set: { transactionStatus: 'PAID' }
                }
            )
        console.log(transaction)
        return transaction.value
    } catch (err) {
        throw err;
    }

}