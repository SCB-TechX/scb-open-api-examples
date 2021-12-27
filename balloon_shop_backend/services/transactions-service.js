const _db = require('../data/db')
const TRANSACTIONS_COLLECTION = 'transactions'

module.exports.saveTransaction = async (transaction) => {
    const result = await _db.instance()
        .collection(TRANSACTIONS_COLLECTION)
        .insertOne(transaction)
    return result
}

module.exports.getTransactionByQrId = async (qrId) => {
    return await _db.instance()
        .collection(TRANSACTIONS_COLLECTION)
        .findOne({ qrId: qrId })

}

module.exports.updateTransactionStatus = async (transactionRef, transactionStatus) => {
    return await _db.instance()
        .collection(TRANSACTIONS_COLLECTION)
        .findOneAndUpdate(
            {
                transactionRef: transactionRef
            },
            {
                $set: { transactionStatus: transactionStatus }
            }
        )
}