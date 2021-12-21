const RandomString = require("randomstring");

/**
 * @return {String} Random string contains A-Z,0-1 with length of 10
 */
module.exports.genarateTransactionReference = () => {
    return RandomString.generate({
        length: 10,
        charset: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    })
}
