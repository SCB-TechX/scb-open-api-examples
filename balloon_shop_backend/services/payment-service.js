const NodeCache = require("node-cache");
const cache = new NodeCache();
const scbApi = require('../apis/scb-api')
const SCB_TOKEN_KEY = 'scb-token';
const ApiResponseCodes = require('../constants/api-response-codes')

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
        return deeplinkResponseData;

    } catch (err) {
        console.log(err)
        throw err;
    }
}