const NodeCache = require("node-cache");
const cache = new NodeCache();

const ApiResponseCodes = require('../constants/api-response-codes')
const scbApi = require('../apis/scb-api')
const RandomString = require("randomstring");

const _db = require('../data/db')

const SCB_TOKEN_KEY = 'scb-token';
const COLLECTION_TRANSACTIONS = 'transactions'

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
    }
    console.log('scbToken:', scbToken)
    return scbToken;
}

const genarateTransactionReference = () => {
    return RandomString.generate({
        length: 10,
        charset: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    })
}

module.exports.createDeeplink = async (user, body) => {
    try {
        const scbToken = await getScbToken();
        const { amount, product } = body
        const transactionRef = genarateTransactionReference()
        const deeplinkResponse = await scbApi.createPaymentDeeplink(scbToken.accessToken, {
            user: user,
            amount: amount,
            product: product,
            transactionRef: transactionRef,
        })
        let deeplinkResponseData = deeplinkResponse.data
        if (!deeplinkResponseData.deeplinkUrl) {
            throw { responseCode: ApiResponseCodes.REQUEST_SCB_CREATE_DEEPLINK_FAIL };
        }
        await _db.instance()
            .collection(COLLECTION_TRANSACTIONS)
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
        const { amount, product } = body
        const transactionRef = genarateTransactionReference()
        const qrResponse = await scbApi.createPaymentQr(scbToken.accessToken, {
            user: user,
            amount: amount,
            product: product,
            transactionRef: transactionRef,
        })
        await _db.instance()
            .collection(COLLECTION_TRANSACTIONS)
            .insertOne({
                transactionStatus: 'PENDING',
                transactionRef: transactionRef,
            })
        const qrResponseData = qrResponse.data
        return qrResponse.data
    } catch (err) {
        throw err;
    }
}

module.exports.paymentConfirmation = async (body) => {
    try {
        const { transactionId } = body
        console.log('tranId', transactionId)
        const transaction = await _db.instance()
            .collection(COLLECTION_TRANSACTIONS)
            .findOneAndUpdate(
                { transactionRef: transactionId },
                { $set: { transactionStatus: 'PAID' } }
            )
        console.log('tran', transaction)
        return transaction.value
    } catch (err) {
        throw err;
    }

}