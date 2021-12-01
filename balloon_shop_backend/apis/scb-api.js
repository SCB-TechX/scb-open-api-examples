const { v4: uuidv4 } = require('uuid');
const axios = require('axios');

const RESOURCE_OWNER_ID = 'for_test'

module.exports.tokenV1 = async () => {
    try {
        const uuid = uuidv4()
        const response = await axios.post(
            process.env.SCB_API_ENDPOINT + '/v1/oauth/token',
            {
                applicationKey: process.env.SCB_API_KEY,
                applicationSecret: process.env.SCB_API_SECRET
            },
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Accept-Language': 'EN',
                    'resourceOwnerId': RESOURCE_OWNER_ID,
                    'requestUId': uuid
                }
            })
        return response.data
    } catch (err) {
        return err.response.data
    }
}

module.exports.createPaymentDeeplink = async (accessToken, req) => {
    try {
        const uuid = uuidv4()
        const response = await axios.post(
            process.env.SCB_API_ENDPOINT + '/v3/deeplink/transactions',
            {
                transactionType: 'PURCHASE',
                transactionSubType: ['BP'],
                sessionValidityPeriod: 600,
                billPayment: {
                    paymentAmount: req.amount,
                    accountTo: process.env.SCB_BILLER_ID,
                    ref1: req.product,
                    ref2: 'ref2',
                    ref3: process.env.SCB_BILLER_REF3_PREFIX + req.user.id
                },
                merchantMetaData: {
                    callbackUrl: 'io.scbtechx.balloonShop://result',
                    merchantInfo: {
                        name: 'Balloon Shop'
                    }
                }
            },
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + accessToken,
                    'Accept-Language': 'EN',
                    'resourceOwnerId': RESOURCE_OWNER_ID,
                    'requestUId': uuid,
                    'channel': 'scbeasy'
                }
            })
        return response.data
    } catch (err) {
        return err.response.data
    }
}