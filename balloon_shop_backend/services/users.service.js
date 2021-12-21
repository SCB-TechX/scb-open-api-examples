const _db = require('../data/db')
const USERS_COLLECTION = 'users'

module.exports.getUserByEmail = async (email) => {
    try {
        return await _db.instance()
            .collection(USERS_COLLECTION)
            .findOne({ email: email })
    } catch (err) {
        return []
    }
}