const { StatusCodes } = require("http-status-codes")
const transactionService = require('../services/transactions-service')
const paymentUtil = require('../utilities/payment-utility')
const scbApi = require('../apis/scb-api')

let waitingQrStatusResponse = {}

/**
 * Create SCB Easy App deeplink from SCB Open API
 * 
 * @param {Express.Request} request
 * @param {Express.Response} response
 */
module.exports.createDeeplink = async (request, response) => {
    try {
        const { user, body } = request
        const { orderedProducts } = body
        const totalPrice = await paymentUtil.calculateTotalPrice(orderedProducts)
        const transactionRef = paymentUtil.genarateTransactionReference()
        const deeplinkResponse = await scbApi.createPaymentDeeplink({
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
        const { user, body } = request
        const { orderedProducts } = body
        const totalPrice = await paymentUtil.calculateTotalPrice(orderedProducts)
        const transactionRef = paymentUtil.genarateTransactionReference()
        const qrResponse = await scbApi.createPaymentQr({
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
 * Callback from SCB server after payment
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
        if (transaction && transaction.qrId) {
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