const { StatusCodes } = require("http-status-codes")
const paymentService = require('../services/payment-service')
const transactionService = require('../services/transactions.service')

let scbToken = {}
let waitingQrStatusResponse = {}

/**
 * 
 * @param {Express.Request} request
 * @param {Express.Response} response
 */
module.exports.createDeeplink = async (request, response) => {
    try {
        const { user, body } = request
        const deeplink = await paymentService.createDeeplink(user, body)
        response.status(StatusCodes.OK).send(deeplink).end()
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
        const qr = await paymentService.createQr(request.user, request.body)
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
module.exports.getTransactionResultByQrId = async (request, response) => {
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

        const { billPaymentRef1 } = body
        const transaction = transactionService.updateTransactionStatus(billPaymentRef1, 'PAID').value

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