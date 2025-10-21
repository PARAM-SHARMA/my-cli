#!/bin/bash

# Check if argument is provided
if [ -z "$1" ]; then
  echo "❌ Error: No feature name provided."
  echo "Usage: ./feature.sh <feature-name>"
  exit 1
fi

FEATURE_NAME=$1
FEATURE_DIR="features/$FEATURE_NAME"
FEATURE_FILE="$FEATURE_DIR/$FEATURE_NAME.controller.js"
ROUTER_FILE="$FEATURE_DIR/$FEATURE_NAME.router.js"
ROUTES_INDEX_FILE="routes/index.js"

# Create the feature directory
mkdir -p "$FEATURE_DIR"

# Write the content to the controller file
cat > "$FEATURE_FILE" <<EOF
const db = require('../../models/index');
const Admin = db.admin;

const ${FEATURE_NAME}Controller = {
  index: (req, res) => {
    res.render('${FEATURE_NAME}/login', {
      title: 'Website | Admin Login',
      user: req.session.user,
      error: res.getFlash('error'),
    });
  },

  login: async (req, res) => {
    const { username, password } = req.body;

    try {
      const admin = await Admin.findAll({
        attributes: ['token', 'username', 'password'],
        where: {
          username: username,
        }
      });

      if (admin[0]) {
        const enc_pass = encrypt(password);
        if (enc_pass == admin[0].password) {
          req.session.user = {
            username: username,
            token: admin[0].token,
          };
          req.setFlash('success', 'Welcome admin');
          return res.redirect('/dashboard');
        } else {
          req.setFlash('error', 'Password does not match');
          return res.redirect('/');
        }
      } else {
        req.setFlash('error', 'Username does not exist');
        return res.redirect('/');
      }
      
    } catch (err) {
      console.log('Login Error:', err);
    }
  },

  getRegister: (req, res) => {
    res.render('${FEATURE_NAME}/register', {
      title: 'Register',
      error: null,
      user: null
    });
  },

  register: async (req, res) => {
    try {
      const { username, email, password } = req.body;

      const enc_pass = encrypt(password);
      const token = randomstring({ length: 64 });
      const current_date = Date.now();

      const admin = {
        token,
        username,
        email,
        password: enc_pass,
        create_date: current_date,
        status: 1,
        flag: 0.
      }

      const data = await Admin.create(admin);
      res.redirect('/');
    } catch (err) {
      console.log('Admin Register:', err);
    }
  },

  logout: async (req, res) => {
    req.session.destroy(err => {
    if (err) {
      console.error('Session destruction error:', err);
      return next(err);
    }
    res.clearCookie('connect.sid', { path: '/' });
    res.redirect('/');
  });
  },
};

module.exports = ${FEATURE_NAME}Controller;
EOF

# Write the content to the router file
cat > "$ROUTER_FILE" <<EOF
const express = require('express');
const router = express.Router();

const ${FEATURE_NAME}Controller = require('./${FEATURE_NAME}.controller');
const sessMiddleware = require('../../middleware/sessionMiddleware');

router.get('/', sessMiddleware, ${FEATURE_NAME}Controller.index);
router.get('/register', ${FEATURE_NAME}Controller.getRegister);

router.post('/', ${FEATURE_NAME}Controller.login);

module.exports = router;
EOF


# ✅ Inject into routes/index.js
if [ -f "$ROUTES_INDEX_FILE" ]; then
  # Only inject if not already present
  if ! grep -q "features/${FEATURE_NAME}/${FEATURE_NAME}.routes" "$ROUTES_INDEX_FILE"; then
    # 1. Add require statement (before module.exports)
    sed -i "/^const router = require('express').Router();/a const ${FEATURE_NAME} = require('../features/${FEATURE_NAME}/${FEATURE_NAME}.routes');" "$ROUTES_INDEX_FILE"

    # 2. Add router.use line
    if [ "$FEATURE_NAME" == "auth" ]; then
      sed -i "/router.use([^)]*/a router.use('/', ${FEATURE_NAME});" "$ROUTES_INDEX_FILE"
    else
      sed -i "/router.use([^)]*/a router.use('/${FEATURE_NAME}', ${FEATURE_NAME});" "$ROUTES_INDEX_FILE"
    fi

    echo "✅ Updated routes/index.js to include $FEATURE_NAME"
  else
    echo "ℹ️  $FEATURE_NAME already exists in routes/index.js — skipping inject"
  fi
else
  echo "❌ routes/index.js not found. Skipping route injection."
fi

echo "✅ Created $FEATURE_NAME"