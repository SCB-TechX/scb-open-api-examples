const { StatusCodes } = require("http-status-codes")
const ApiResponseCodes = require('../constants/api-response-codes')

const errorHandler = (err, req, res, next) => {
    switch (err.responseCode) {
        case ApiResponseCodes.INVALID_EMAIL_OR_PASSWORD:
            return res.status(StatusCodes.UNAUTHORIZED).send({
                code: err.responseCode,
                developer_message: 'invalid email or password'
            })
        case ApiResponseCodes.INVALID_TOKEN:
            return res.status(StatusCodes.UNAUTHORIZED).send({
                code: err.responseCode,
                developer_message: 'invalid token'
            })
        case ApiResponseCodes.REQUEST_SCB_TOKEN_FAIL:
            return res.status(StatusCodes.INTERNAL_SERVER_ERROR).send({
                code: err.responseCode,
                developer_message: 'fail to request scb token'
            })
        case ApiResponseCodes.REQUEST_SCB_CREATE_DEEPLINK_FAIL:
            return res.status(StatusCodes.INTERNAL_SERVER_ERROR).send({
                code: err.responseCode,
                developer_message: 'fail to request scb create deeplink'
            })
        case ApiResponseCodes.REQUEST_SCB_CREATE_QR_FAIL:
            return res.status(StatusCodes.INTERNAL_SERVER_ERROR).send({
                code: err.responseCode,
                developer_message: 'fail to request scb create qr'
            })
        default:
            return res.status(StatusCodes.INTERNAL_SERVER_ERROR).send({
                code: ApiResponseCodes.INTERNAL_SERVER_ERROR,
                developer_message: 'internal server error'
            })
    }
}

module.exports = errorHandler