const NodeCache = require("node-cache");
const cache = new NodeCache();
const scbApi = require('../apis/scb-api')
const SCB_TOKEN_KEY = 'scb-token';
const ApiResponseCodes = require('../constants/api-response-codes')
const _db = require('../data/db')

module.exports.createDeeplink = async (user, body) => {
    try {
        let scbToken = cache.get(SCB_TOKEN_KEY)
        const { amount, product } = body
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
        let deeplinkResponse = await scbApi.createPaymentDeeplink(scbToken.accessToken, {
            user: user,
            amount: amount,
            product: product
        })
        let deeplinkResponseData = deeplinkResponse.data
        if (!deeplinkResponseData.deeplinkUrl) {
            throw { responseCode: ApiResponseCodes.REQUEST_SCB_CREATE_DEEPLINK_FAIL };
        }
        await _db.instance()
            .collection('transactions')
            .insertOne({
                transactionId: deeplinkResponseData.transactionId,
                transactionStatus: 'PENDING',
                userRefId: deeplinkResponseData.userRefId,

            })
        return deeplinkResponseData;

    } catch (err) {
        throw err;
    }
}

module.exports.paymentConfirmation = async (body) => {
    try {
        const { transactionId } = body
        const transaction = await _db.instance()
            .collection('transactions')
            .findOneAndUpdate(
                { transactionId: transactionId },
                { $set: { transactionStatus: 'PAID' } }
            )
        return transaction.value
    } catch (err) {
        throw err;
    }

}