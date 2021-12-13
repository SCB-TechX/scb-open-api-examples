const passport = require('passport')
const ExtractJwt = require("passport-jwt").ExtractJwt;
const JwtStrategy = require("passport-jwt").Strategy;
const userService = require('../services/user-service')
const ApiResponseCodes = require('../constants/api-response-codes')

const opts = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: process.env.SERVER_JWT_SECRET,
}

const isTokenExpire = (payload) => {
    if (!payload.exp) {
        return true;
    }
    const currentDate = new Date();
    if (currentDate.getTime() > payload.exp) {
        return true;
    }
    return false;
}

const jwtStrategy = new JwtStrategy(opts, (payload, done) => {

    if (isTokenExpire(payload)) {
        throw 'token is expire';
    }

    const user = userService.getUser(payload.sub)
    if (!user) {
        throw 'user not found';
    }
    return done(null, user)
});

const authenticateJwt = (req, res, next) => {
    passport.authenticate(jwtStrategy, { session: false }, (err, user, info) => {
        if (info || err) {
            throw { responseCode: ApiResponseCodes.INVALID_TOKEN }
        }
        req.user = user;
        return next();
    })(req, res, next);
}

module.exports = authenticateJwt
