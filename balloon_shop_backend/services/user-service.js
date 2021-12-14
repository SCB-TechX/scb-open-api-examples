const safeCompare = require('safe-compare')
const _db = require('../data/db')

module.exports.getUserByEmail = async (email) => {
    try {
        const users = await _db.instance()
            .collection('users')
            .find({ email: email })
            .toArray();

        return users.find((user) => safeCompare(user.email, email))
    } catch (err) {
        return []
    }
}