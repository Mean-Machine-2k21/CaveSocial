const mongoose = require('mongoose');

const MuralSchema = new mongoose.Schema({
    content: {
        type: String,
        required: true,
        trim: true,
    },
    likes: {
        type: [{
            likedByUserId: {
                type: mongoose.Schema.Types.ObjectId,
                required: true,
                ref: 'User'
            }
        }]
    },
    comments: {
        type: [{
            muralCommentId: {
                type: mongoose.Schema.Types.ObjectId,
                required: true,
                ref: 'Mural'
            }
        }],
    },
    creator: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User',
        index: true
    },
    isComment: {
        type: Boolean,
        required: true,
        default: false
    },
    isFlipBook: {
        type: String,
        required: true,
        default: 'normal'
    },
    flipbook: {
        type: {
            frames: {
                type: Number,
                required: true,
            },
            duration: {
                type: Number,
                required: true
            }
        },
        required: false
    }

}, {
    timestamps: true
});

const Mural = new mongoose.model('Mural', MuralSchema);

module.exports = Mural;