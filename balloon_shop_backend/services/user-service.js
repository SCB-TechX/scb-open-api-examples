const safeCompare = require('safe-compare')
const users = require('../data/users.json')

module.exports.getUser = (email) => {
    return users.find((user) => safeCompare(user.email, email))
}