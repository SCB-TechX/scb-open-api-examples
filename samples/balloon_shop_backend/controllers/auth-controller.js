const jwt = require('jsonwebtoken');
const passport = require('passport');
const BearerStrategy = 

passport.use(new BearerStrategy(
    function(token, done) {
      User.findOne({ token: token }, function (err, user) {
        if (err) { return done(err); }
        if (!user) { return done(null, false); }
        return done(null, user, { scope: 'read' });
      });
    }
  ));

exports.login = (req, res, next) => {
    
    Auth.findOne({email: req.body.email})
        .then( user => {
            if(!user){
                return res.status(401).json({
                    message: 'User does not exist!'
                });
            }
            // console.log("login: ", user)
            bcrypt.compare(req.body.password, user.password)
            .then(result => {
                if(!result){
                    return res.status(401).json({
                        message: 'Autentication Failed!',
                        status: result,
                    });
                }
                else{
                    login_role = user.role;
                    const token = jwt.sign(
                        {email: user.emit, user_id: user._id}, 
                        private_Key, 
                        {expiresIn:'1h'} );
                    
                    return res.status(401).json({
                        message: 'Autenticated successfully!',
                        token: token,
                    });
                }
    
            })
            .catch( err => {
                return res.status(401).json({
                    message: 'Error occured in authentication!',
                    error: err,
                });
            });

        });
        
}