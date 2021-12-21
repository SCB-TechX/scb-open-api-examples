const _db = require('../data/db')
const TRANSACTIONS_COLLECTION = 'transactions'

module.exports.saveTransaction = async (transaction) => {
    try {
        const result = await _db.instance()
            .collection(TRANSACTIONS_COLLECTION)
            .insertOne(transaction)
        return result
    } catch (err) {
        throw err
    }
}

module.exports.getTransactionByQrId = async (qrId) => {
    try {
        return await _db.instance()
            .collection(TRANSACTIONS_COLLECTION)
            .findOne({ qrId: qrId })
    } catch (err) {
        throw err
    }
}