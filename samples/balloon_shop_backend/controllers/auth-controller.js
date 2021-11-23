const { StatusCodes } = require('http-status-codes')
const safeCompare = require('safe-compare')
const jwt = require("jwt-simple");
const userService = require('../services/user-service')

module.exports.token = async (req, res) => {

    const { email, password } = req.body
    const user = userService.getUser(email)
    if (!user || !safeCompare(user.password, password)) {
        res.status(StatusCodes.UNAUTHORIZED).send({
            code: 40101,
            developer_message: 'invalid credentials'
        })
    }

    const payload = {
        sub: req.body.email,
        iat: new Date().getTime()
    };

    const SECRET = process.env.SECRET;
    res.send({ access_token: jwt.encode(payload, SECRET) });
}