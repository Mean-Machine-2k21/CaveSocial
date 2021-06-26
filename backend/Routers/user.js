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
        res.status(200).json({ msg: 'Logged Out Successfully' });
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
        res.status(200).json({ msg: 'Logged Out Of All devices' });
    }
    catch (e) {
        console.log(e);
        res.status(500).send();
    }
});

router.patch('/api/editprofile', auth, async (req, res) => {
    try {
        req.user.avatar_url = req.body.avatar_url ? req.body.avatar_url : (req.user.avatar_url ? req.user.avatar_url : "");
        req.user.bio_url = req.body.bio_url ? req.body.bio_url : (req.user.bio_url ? req.user.bio_url : "");
        console.log(req.user);
        await req.user.save();
        res.status(200).json({ msg: 'Congratulations profile updated successfully', user: req.user });
    }
    catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});

router.get('/api/profile/:username', auth, async (req, res) => {
    const username = req.params.username;
    const pageNumber = req.query.pagenumber;
    const nPerPage = 6;
    try {
        const user = await User.find({ username });
        console.log(user);
        if (!user[0]) {
            return res.status(400).json({ msg: 'User Not Found' });
        }
        const murals = await Mural.aggregate([
            { $match: { isComment: false, creatorUsername: username } },
            {
                $project: {
                    _id: 1, imageUrl: "$content", creatorUsername: 1, creatorId: 1, likedCount: { $size: "$likes" },
                    commentCount: { $size: "$comments" }, flipbook: 1,
                    isLiked: { $in: [req.user.username, "$likes.likedByUserName"] }
                }
            },
            { $sort: { _id: 1 } },
            { $skip: pageNumber * nPerPage },
            { $limit: nPerPage }
        ]);
        res.status(200).json({ msg: 'User Found', user: user[0], murals });
    } catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});
module.exports = router;