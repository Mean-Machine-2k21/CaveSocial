const express = require('express');
const router = new express.Router();
const User = require('../Models/User');
const Mural = require('../Models/Mural');
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
        res.send({ user: user, token, body: req.body });
    }
    catch (err) {
        console.log(err);
        res.statusCode = 401;
        res.json({
            msg: err.message, body: req.body
        });
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

router.patch('/api/editprofile', auth, async (req, res) => {
    try {
        req.user.avatar_url = req.body.avatar_url;
        req.user.bio_url = req.body.bio_url;
        console.log(req.user);
        await req.user.save();
        res.status(200).json({ msg: 'Congratulations profile updated successfully', user: req.user });
    }
    catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});
router.get('/api/profile/:id', auth, async (req, res) => {
    const _id = req.params.id;

    if (!_id.match(/^[0-9a-fA-F]{24}$/)) {
        return res.status(404).send();
    }

    try {
        const user = await User.findById(_id);
        const murals = await Mural.find({ creator: req.user._id }).select('-creator').exec();
        if (!user) {
            return res.status(404).json({ msg: 'Not Authenticated' });
        }
        res.status(200).json({ msg: 'Profile Found', user, murals });
    } catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});

module.exports = router;