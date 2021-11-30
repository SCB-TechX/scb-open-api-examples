const NodeCache = require("node-cache");
const cache = new NodeCache();

const scbApi = require('../apis/scb-api')
const SCB_TOKEN_KEY = 'scb-token';

module.exports.createDeeplink = async (user, body) => {
    try {
        let scbToken = cache.get(SCB_TOKEN_KEY)
        const { amount } = body
        if (!scbToken
            || !scbToken.accessToken
            || !scbToken.expireDate
            || scbToken.expireDate < Date.now()) {

            let tokenResponse = await scbApi.tokenV1()
            let tokenResponseData = tokenResponse.data
            if (!tokenResponseData
                || !tokenResponseData.accessToken
                || !tokenResponseData.expiresAt) {
                throw tokenResponseData;
            }
            scbToken = {
                ...tokenResponseData,
                expireDate: new Date(tokenResponseData.expiresAt * 1000)
            }
            console.log('scbToken', scbToken)
            cache.set(SCB_TOKEN_KEY, scbToken)
        }

        let deeplinkResponse = await scbApi.createPaymentDeeplink(scbToken.accessToken, {
            user: user,
            amount: amount
        })
        let deeplinkResponseData = deeplinkResponse.data
        console.log(deeplinkResponseData)
        if (!deeplinkResponseData.deeplinkUrl) {
            throw deeplinkResponseData;
        }
        return deeplinkResponseData;

    } catch (err) {

    }
}