const { StatusCodes } = require("http-status-codes")
const ApiResponseCodes = require('../constants/api-response-codes')

const errorHandler = (err, req, res, next) => {
    switch (err.responseCode) {
        case ApiResponseCodes.INVALID_EMAIL_OR_PASSWORD:
            return res.status(StatusCodes.UNAUTHORIZED).send({
                code: err.responseCode,
                developer_message: 'invalid email or password'
            });
        case ApiResponseCodes.INVALID_TOKEN:
            return res.status(StatusCodes.UNAUTHORIZED).send({
                code: err.responseCode,
                developer_message: 'invalid token'
            })
        default:
            return res.status(StatusCodes.INTERNAL_SERVER_ERROR).send({
                code: ApiResponseCodes.INTERNAL_SERVER_ERROR,
                developer_message: 'internal server error'
            });
    }
}

module.exports = errorHandler