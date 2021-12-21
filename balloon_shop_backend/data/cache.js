const NodeCache = require("node-cache")
const cache = new NodeCache()

const SCB_TOKEN_KEY = 'scb-token'
const WAITING_QR_RESPONSE_PREFIX = 'waiting-qr-'

module.exports.setScbToken = (scbToken) => {
    cache.set(SCB_TOKEN_KEY, scbToken)
}

module.exports.getScbToken = () => {
    return cache.get(SCB_TOKEN_KEY)
}

module.exports.setWaitingResponse = (qrId, response) => {
    cache.set(WAITING_QR_RESPONSE_PREFIX + qrId, response)
}

module.exports.getWaitingResponse = () => {
    return cache.get(WAITING_QR_RESPONSE_PREFIX + qrId)
}

module.exports.deleteWaitingResponse = (qrId) => {
    cache.del(WAITING_QR_RESPONSE_PREFIX + qrId)
}