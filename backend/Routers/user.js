const express = require('express');
const router = new express.Router();
const User = require('../Models/User');
const auth = require('../Middleware/Auth');


router.post('/api/signup', async (req, res, next) => {

    try {
        const user = new User(req.body);
        await user.save();
        const token = await user.generateAuthToken();
        res.status(201).send({ user, token });
    } catch (error) {
        next(error);
    }
});


router.post('/api/login', async (req, res) => {
    console.log('hello');
    try {
        const user = await User.findByCredentials(req.body.username, req.body.password);
        const token = await user.generateAuthToken();
        res.send({ user: user, token });
    }
    catch (err) {
        console.log(err);
        res.statusCode = 401;
        res.json({ msg: err.message });
    }
});

router.post('/api/logout', auth, async (req, res) => {

    try {
        req.user.tokens = req.user.tokens.filter((token) => {
            return token.token !== req.token;
        });
        await req.user.save();

        res.send();
    }
    catch (e) {
        console.log(e);
        res.status(500).send();
    }

});


router.post('/api/logoutall', auth, async (req, res) => {
    try {
        req.user.tokens = [];
        await req.user.save();
        res.status(200).send();
    }
    catch (e) {
        console.log(e);
        res.status(500).send();
    }
});

module.exports = router;