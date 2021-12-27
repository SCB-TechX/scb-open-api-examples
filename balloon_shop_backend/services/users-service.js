const _db = require('../data/db')
const USERS_COLLECTION = 'users'

module.exports.getUserByEmail = async (email) => {
    return await _db.instance()
        .collection(USERS_COLLECTION)
        .findOne({ email: email })
}