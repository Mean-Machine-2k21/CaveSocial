const express = require('express');
const router = new express.Router();
const User = require('../Models/User');
const Mural = require('../Models/Mural');
const auth = require('../Middleware/Auth');
const ObjectId = require("mongodb").ObjectId;

router.post('/api/createmural', auth, async (req, res) => {
    // console.log(req.user);
    try {
        let mural;
        if (req.body.flipbook) {
            mural = new Mural(
                {
                    content: req.body.content,
                    creatorId: req.user._id,
                    creatorUsername: req.user.username,
                    flipbook: {
                        frames: req.body.flipbook.frames,
                        duration: req.body.flipbook.duration
                    }
                });
        }
        else {
            mural = new Mural(
                {
                    content: req.body.content,
                    creatorId: req.user._id,
                    creatorUsername: req.user.username,
                });
        }
        const response = await mural.save();
        res.status(200).json({ msg: 'Congratulations Mural Created Successfully', mural: response._doc });
    }
    catch (error) {
        console.log(error);
        res.status(400).json({ msg: 'Something went wrong' });
    }
});
router.patch('/api/likemural/', auth, async (req, res) => {
    // console.log(req.user);
    try {
        const _id = req.body.muralId;
        const mural = await Mural.findById(_id);
        // const alreadyLiked = mural.likes.some(like => like.likedByUserId.toString() === req.user._id.toString());
        // if (alreadyLiked)
        //     return res.status(200).json({ msg: 'Mural Already Liked' });
        // const likes = mural.likes.concat({ likedByUserId: req.user._id, likedByUserName: req.user.username });
        // mural.likes = likes;
        // const response = await mural.save();

        const updateMuralRes = await Mural.updateOne({ _id: ObjectId(_id) }, { $addToSet: { likes: [ObjectId(req.user._id)] } });
        res.status(200).json({ msg: 'Mural Liked' });
    }
    catch (error) {
        console.log(error);
        res.status(400).json({ msg: 'Something went wrong' });
    }
});
router.patch('/api/unlikemural/', auth, async (req, res) => {

    try {
        const _id = req.body.muralId;
        // const mural = await Mural.findById(_id);
        // const likes = mural.likes.filter(like => like.likedByUserId.toString() !== req.user._id.toString());
        // mural.likes = likes;
        // const response = await mural.save();
        const updateMuralRes = await Mural.updateOne({ _id: ObjectId(_id) }, { $pull: { likes: ObjectId(req.user._id) } });
        res.status(200).json({ msg: 'Mural Unliked' });
    }
    catch (error) {
        console.log(error);
        res.status(400).json({ msg: 'Something went wrong' });
    }
});
router.post('/api/commentonmural/:id', auth, async (req, res) => {
    const _id = req.params.id;
    try {
        if (!_id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(404).send();
        }
        let commentMural;
        if (req.body.flipbook) {
            commentMural = new Mural(
                {
                    content: req.body.content,
                    creatorId: req.user._id,
                    creatorUsername: req.user.username,
                    flipbook: {
                        frames: req.body.flipbook.frames,
                        duration: req.body.flipbook.duration
                    },
                    isComment: true
                });
        }
        else {
            commentMural = new Mural(
                {
                    content: req.body.content,
                    creatorId: req.user._id,
                    creatorUsername: req.user.username,
                    isComment: true
                });
        }
        const commentMuralResponsive = await commentMural.save();
        // const mural = await Mural.findById(_id);
        // const comments = mural.comments.concat({ muralCommentId: commentMuralResponsive._doc._id });
        // mural.comments = comments;
        // const response = await mural.save();
        const updateCommentsOfMural = await Mural.updateOne({ _id: ObjectId(_id) }, { $addToSet: { comments: [ObjectId(commentMuralResponsive._doc._id)] } });
        res.status(200).json({ msg: 'Commented On Mural', mural: commentMuralResponsive._doc });
    }
    catch (error) {
        console.log(error);
        res.status(400).json({ msg: 'Something went wrong' });
    }
});
router.get('/api/murals', auth, async (req, res) => {
    try {
        const pageNumber = req.query.pagenumber;
        const nPerPage = 5;
        const response = await Mural.aggregate([
            { $match: { isComment: false } },
            {
                $project: {
                    _id: 1, imageUrl: "$content", creatorUsername: 1, creatorId: 1, likedCount: { $size: "$likes" },
                    commentCount: { $size: "$comments" }, flipbook: 1,
                    isLiked: { $in: [ObjectId(req.user._id), "$likes"] }
                }
            },
            { $sort: { _id: -1 } },
            { $skip: pageNumber * nPerPage },
            { $limit: nPerPage }
        ]);

        // console.log(response);
        res.status(200).json({ murals: response });
    } catch (error) {
        console.log(error);
        res.status(400).json({ msg: 'Something went wrong' });
    }
});
router.get('/api/following/murals', auth, async (req, res) => {
    try {
        const pageNumber = req.query.pagenumber;
        const nPerPage = 5;
        const response = await Mural.aggregate([
            { $match: { isComment: false, creatorId: { $in: [...req.user.following, req.user._id] } } },
            {
                $project: {
                    _id: 1, imageUrl: "$content", creatorUsername: 1, creatorId: 1, likedCount: { $size: "$likes" },
                    commentCount: { $size: "$comments" }, flipbook: 1,
                    isLiked: { $in: [ObjectId(req.user._id), "$likes"] }
                }
            },
            { $sort: { _id: -1 } },
            { $skip: pageNumber * nPerPage },
            { $limit: nPerPage }
        ]);

        // console.log(response);
        res.status(200).json({ murals: response });
    } catch (error) {
        console.log(error);
        res.status(400).json({ msg: 'Something went wrong' });
    }
});

router.get('/api/commentsonmural/:id', auth, async (req, res) => {
    const _id = req.params.id;

    try {
        if (!_id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(404).send();
        }
        const pageNumber = req.query.pagenumber;
        const nPerPage = 5;
        const muralCommentsResponse = await Mural.findById(_id).select({ comments: 1 });
        // const objectIdArrays = muralResponse.comments.map(item => {
        //     return ObjectId(item.muralCommentId);
        // });
        // console.log(muralCommentsResponse.comments);
        const objectIdArrays = muralCommentsResponse.comments;
        // console.log(objectIdArrays);
        const response = await Mural.aggregate([
            { $match: { isComment: true, _id: { $in: objectIdArrays } } },
            {
                $project: {
                    _id: 1, imageUrl: "$content", creatorUsername: 1, creatorId: 1, likedCount: { $size: "$likes" }, commentCount: { $size: "$comments" },
                    flipbook: 1,
                    isLiked: { $in: [ObjectId(req.user._id), "$likes"] }
                }
            },
            { $sort: { _id: -1 } },
            { $skip: pageNumber * nPerPage },
            { $limit: nPerPage }
        ]);

        // console.log(response);
        res.status(200).json({ comments: response });
    } catch (error) {
        console.log(error);
        res.status(400).json({ msg: 'Something went wrong' });
    }
});
router.get('/api/likesonmural/:id', auth, async (req, res) => {
    const _id = req.params.id;

    try {
        if (!_id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(404).send();
        }
        const muralLikes = await Mural.findById(_id)
            .select({ likes: 1 })
            .populate({ path: "likes", select: "_id username avatar_url" });
        // console.log(muralLikes);
        res.status(200).json({ likes: muralLikes.likes });
    } catch (error) {
        console.log(error);
        res.status(400).json({ msg: 'Something went wrong' });
    }
});


module.exports = router;
