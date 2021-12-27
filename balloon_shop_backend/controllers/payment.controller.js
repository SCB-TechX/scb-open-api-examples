const { StatusCodes } = require("http-status-codes")
const transactionService = require('../services/transactions.service')
const productService = require('../services/product.service')
const paymentUtil = require('../utilities/payment.utility')
const scbApi = require('../apis/scb-api')

let scbToken = {}
let waitingQrStatusResponse = {}

const getScbToken = async () => {
    if (!scbToken
        || !scbToken.accessToken
        || !scbToken.expireDate
        || scbToken.expireDate < Date.now()) {

        let tokenResponse = await scbApi.tokenV1()
        let tokenResponseData = tokenResponse.data
        if (!tokenResponseData
            || !tokenResponseData.accessToken
            || !tokenResponseData.expiresAt) {
            throw { responseCode: ApiResponseCodes.REQUEST_SCB_TOKEN_FAIL }
        }
        scbToken = {
            ...tokenResponseData,
            expireDate: new Date(tokenResponseData.expiresAt * 1000)
        }
        console.log('scbToken:', scbToken)
    }
    return scbToken
}
const calculateTotalPrice = async (orderedProducts) => {
    let totalPrice = 0.00
    const products = await productService.getProducts()
    orderedProducts.forEach(orderedProduct => {
        const product = products.find(product => product._id.toString() === orderedProduct._id)
        if (product) {
            totalPrice = totalPrice + (product.price * orderedProduct.amount)
        } else {
            console.log('product', product)
            throw {}
        }
    })
    console.log('totalPrice', totalPrice)
    return totalPrice
}

/**
 * 
 * @param {Express.Request} request
 * @param {Express.Response} response
 */
module.exports.createDeeplink = async (request, response) => {
    try {
        const { user, body } = request
        const scbToken = await getScbToken()
        const { orderedProducts } = body
        const totalPrice = await calculateTotalPrice(orderedProducts)
        const transactionRef = paymentUtil.genarateTransactionReference()
        const deeplinkResponse = await scbApi.createPaymentDeeplink(scbToken.accessToken, {
            user: user,
            amount: totalPrice,
            transactionRef: transactionRef,
        })
        let deeplinkResponseData = deeplinkResponse.data
        if (!deeplinkResponseData.deeplinkUrl) {
            throw { responseCode: ApiResponseCodes.REQUEST_SCB_CREATE_DEEPLINK_FAIL }
        }
        transactionService.saveTransaction({
            transactionId: deeplinkResponseData.transactionId,
            transactionStatus: 'PENDING',
            transactionRef: transactionRef,
            paymentMethod: 'deeplink',
            userRefId: deeplinkResponseData.userRefId,

        })
        response.status(StatusCodes.OK).send(deeplinkResponseData).end()
    } catch (err) {
        throw err
    }
}

/**
 * Create QR code from SCB Open API
 * 
 * @param {Express.Request} request
 * @param {Express.Response} response
 */
module.exports.createQr = async (request, response) => {
    try {
        const scbToken = await getScbToken()
        const { orderedProducts } = body
        const totalPrice = await calculateTotalPrice(orderedProducts)
        const transactionRef = paymentUtil.genarateTransactionReference()
        const qrResponse = await scbApi.createPaymentQr(scbToken.accessToken, {
            user: user,
            amount: totalPrice,
            transactionRef: transactionRef,
        })

        const qrResponseData = qrResponse.data
        transactionService.saveTransaction({
            transactionStatus: 'PENDING',
            transactionRef: transactionRef,
            qrId: qrResponseData.qrcodeId,
            paymentMethod: 'qr',
        })
        const qr = qrResponse.data
        response.status(StatusCodes.OK).send(qr).end()
    } catch (err) {
        throw err
    }
}


/**
 * Get transaction by qrId from request 
 * Support long polling to wait for transactionStutus = 'PAID' 
 * 
 * @param {Express.Request} request
 * @param {Express.Response} response
 */
module.exports.getPaymentQrResult = async (request, response) => {
    try {
        const { qrId } = request.query
        if (!qrId) {
            throw {} // invalid params
        }

        const transaction = await transactionService.getTransactionByQrId(qrId)
        if (!transaction) {
            throw {}// transaction not found
        }

        if (transaction.transactionStatus === 'PAID') {
            response.status(StatusCodes.OK).send(transaction).end()
        } else {
            waitingQrStatusResponse[qrId] = response
        }

    } catch (err) {
        throw err
    }
}

/**
 * 
 * @param {Express.Request} request
 * @param {Express.Response} response
 */
module.exports.paymentConfirmation = async (req, res) => {
    try {
        console.log('paymentConfirmation', 'BODY:', req.body)
        const { billPaymentRef1 } = req.body
        const record = await transactionService.updateTransactionStatus(billPaymentRef1, 'PAID')
        const transaction = record.value
        if (transaction.qrId) {
            const waitingResponse = waitingQrStatusResponse[transaction.qrId]
            if (waitingResponse) {
                waitingResponse.status(StatusCodes.OK).send(transaction).end()
                delete waitingQrStatusResponse[transaction.qrId]
            }
        }
        res.status(StatusCodes.OK).send(transaction).end()
    } catch (err) {
        throw err
    }
}