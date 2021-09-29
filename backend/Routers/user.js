const express = require('express');
const router = new express.Router();
const User = require('../Models/User');
const Mural = require('../Models/Mural');
const auth = require('../Middleware/Auth');
const mongoose = require('mongoose');
const ObjectId = require("mongodb").ObjectId;

router.post('/api/signup', async (req, res, next) => {
    try {
        const user = new User(
            {
                ...req.body,
                avatar_url: 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                bio_url: 'https://empire-s3-production.bobvila.com/articles/wp-content/uploads/2020/04/Types-of-Wall-Texture-sand-swirl.jpg'
            });
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

router.get('/api/profile/:id', auth, async (req, res) => {
    const _id = req.params.id;
    try {
        if (!_id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(404).send();
        }
        const user = await User.findOne({ _id }, { followersCount: { $size: "$followers" }, followingCount: { $size: "$following" }, username: 1, avatar_url: 1, bio_url: 1, isFollowed: { $in: [ObjectId(req.user._id), "$followers"] } })
            .exec();
        if (!user) {
            return res.status(400).json({ msg: 'User Not Found' });
        }
        console.log(user);

        // console.log(user);
        const murals = await Mural.aggregate([
            { $match: { isComment: false, creatorId: user._id } },
            {
                $project: {
                    _id: 1, imageUrl: "$content", creatorUsername: 1, creatorId: 1, likedCount: { $size: "$likes" },
                    commentCount: { $size: "$comments" }, flipbook: 1,
                    isLiked: { $in: [ObjectId(req.user._id), "$likes"] }
                }
            },
            { $sort: { _id: -1 } }
        ]);
        res.status(200).json({
            msg: 'User Found', user, murals
        });
    } catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});
router.get('/api/user/:id/followers', auth, async (req, res) => {
    const _id = req.params.id;
    try {
        if (!_id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(404).send();
        }
        // console.log(typeof(req.user.following[0]));
        const followersInfo = await User.findOne({ _id }, { followersCount: { $size: "$followers" } })
            .populate({ path: "followers", select: "_id username avatar_url" })
            .exec();
        if (!followersInfo) {
            return res.status(400).json({ msg: 'User Not Found' });
        }

        const followingSet = new Set();
        req.user.following.forEach(followingId => { followingSet.add(followingId.toString()); });
        followersObj = followersInfo.toObject();
        followersObj.followers.forEach(follower => {
            follower['isFollowed'] = followingSet.has(follower._id.toString());
            return follower;
        });
        // console.log(followersInfo);

        res.status(200).json({
            msg: 'User Found', ...followersObj,
        });
    } catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});
router.get('/api/user/:id/following', auth, async (req, res) => {
    const _id = req.params.id;
    try {
        if (!_id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(404).send();
        }
        const followingInfo = await User.findOne({ _id }, { followingCount: { $size: "$following" } })
            .populate({ path: "following", select: "_id username avatar_url" })
            .exec();
        if (!followingInfo) {
            return res.status(400).json({ msg: 'User Not Found' });
        }
        const followingSet = new Set();
        req.user.following.forEach(followingId => { followingSet.add(followingId.toString()); });
        followingInfoObj = followingInfo.toObject();
        followingInfoObj.following.forEach(following => {
            following['isFollowed'] = followingSet.has(following._id.toString());
            return following;
        });

        res.status(200).json({
            msg: 'User Found', ...(followingInfoObj),
        });
    } catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});
router.put('/api/follow/:id', auth, async (req, res) => {
    const _id = req.params.id;
    try {
        if (!_id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(404).send();
        }
        console.log(req.user);
        const updatedUser1Res = await User.updateOne({ _id: ObjectId(req.user._id) }, { $addToSet: { following: [ObjectId(_id)] } });
        const updatedUser2Res = await User.updateOne({ _id: ObjectId(_id) }, { $addToSet: { followers: [ObjectId(req.user._id)] } });
        res.status(200).json({ msg: 'User followed' });
    } catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});
router.put('/api/unfollow/:id', auth, async (req, res) => {
    const _id = req.params.id;
    try {
        const updatedUser1Res = await User.updateOne({ _id: ObjectId(req.user._id) }, { $pull: { following: ObjectId(_id) } });
        const updatedUser2Res = await User.updateOne({ _id: ObjectId(_id) }, { $pull: { followers: ObjectId(req.user._id) } });
        res.status(200).json({ msg: 'User unfollowed' });
    } catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});
router.get('/api/search/profile', auth, async (req, res) => {
    try {
        let searchTerm = req.query.searchTerm;
        searchTerm = searchTerm.replace(/\s+/g, '');
        if (searchTerm.length === 1)
            return res.status(200).json({
                msg: 'Users Found', users: [],
            });
        searchTerm = searchTerm.replace('_', ' ');
        console.log(searchTerm + "a");
        const users = await User.fuzzySearch({ query: searchTerm, exact: true }).select({ _id: 1, username: 1, avatar_url: 1 }).exec();
        console.log('came here');
        res.status(200).json({
            msg: 'sexc profiles  Found', users,
        });
    } catch (error) {
        console.log(error);
        res.status(500).send({ msg: 'Something Went Wrong' });
    }
});
module.exports = router;