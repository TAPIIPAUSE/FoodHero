import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';


dotenv.config();

export function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  console.log("Token received for verification:", token);


  if (token == null) return res.status(401).send("No JWT Token");

  jwt.verify(token, process.env.TOKEN_SECRET, (err, user) => {
    console.log(err);

    if (err) return res.status(403).send("JWT token doesn't match");

    req.user = user;

    next();
  });
}

export function authenticateCookieToken(req, res, next){
  // Get token from cookies
  const token = req.cookies.token;

  console.log("This is cookie information:", req.cookies.token)

  if (!token) return res.status(401).send('Access Denied');

  jwt.verify(token, process.env.TOKEN_SECRET, (err, user) => {
      if (err) return res.status(403).send('Expired Token');
      req.user = user; // Attach user info to the request object
      next();
  });
};


