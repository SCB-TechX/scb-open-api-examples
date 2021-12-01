const passport = require('passport')
const ExtractJwt = require("passport-jwt").ExtractJwt;
const JwtStrategy = require("passport-jwt").Strategy;
const userService = require('../services/user-service')

const opts = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: process.env.JWT_SECRET,
    ignoreExpiration: false
}

const jwtStrategy = new JwtStrategy(opts, (payload, done) => {
    const user = userService.getUser(payload.sub)
    if (user) {
        return done(null, user)
    } else {
        return done(null, false)
    }
});

passport.use(jwtStrategy)
const authJwt = passport.authenticate("jwt", { session: false });

module.exports = authJwt
