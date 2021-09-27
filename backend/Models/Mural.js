const mongoose = require('mongoose');

const MuralSchema = new mongoose.Schema({
    content: {
        type: String,
        required: true,
        trim: true,
    },
    likes: {
        type: [{
            type: mongoose.Schema.Types.ObjectId,
            required: true,
            ref: 'User'
        }]
    },
    comments: {
        type: [{
            type: mongoose.Schema.Types.ObjectId,
            required: true,
            ref: 'Mural'
        }]
    },
    creatorId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User',
        index: true
    },
    creatorUsername: {
        type: String,
        required: true,
        ref: 'User',
    },
    isComment: {
        type: Boolean,
        required: true,
        default: false
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
// (async () => {
//     try {
//         const murals = await Mural2.find();
//         for (let mural of murals) {
//             const newMural = new Mural({
//                 _id: mural._id,
//                 isComment: mural.isComment,
//                 content: mural.content,
//                 creatorId: mural.creatorId,
//                 creatorUsername: mural.creatorUsername,
//                 createdAt: mural.createdAt,
//                 updatedAt: mural.updateAt,
//                 __v: mural.__v,
//                 likes: mural.likes,
//                 comments: mural.comments
//             });
//             await newMural.save();
//         }
//     } catch (error) {
//         console.log(error);
//     }
// })();

module.exports = Mural;