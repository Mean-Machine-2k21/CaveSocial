const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const mongoose_fuzzy_searching = require('mongoose-fuzzy-searching');
const ObjectId = require("mongodb").ObjectId;
// mongoose.connect("mongodb+srv://taskapp:taskapp123@cluster0.laatv.mongodb.net/CaveSocial?retryWrites=true", {
//     useNewUrlParser: true,
//     useCreateIndex: true,
//     useUnifiedTopology: true,
//     useFindAndModify: false
// });



const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        trim: true,
        unique: true,
        index: true
    },
    password: {
        type: String,
        required: true,
        trim: true,
        minlength: 7,
        validate(value) {
            if (value.toLowerCase().includes('password')) {
                throw new Error('Password Must not include the word "password"');
            }
        }
    },
    tokens: [{
        token: {
            type: String,
            required: true
        }
    }],
    avatar_url: {
        type: String,
    },
    bio_url: {
        type: String
    },
    followers: {
        type: [{
            type: mongoose.Schema.Types.ObjectId,
            required: true,
            ref: 'User'
        }]
    },
    following: {
        type: [{
            type: mongoose.Schema.Types.ObjectId,
            required: true,
            ref: 'User'
        }]
    },

}, {
    timestamps: true
});


userSchema.methods.toJSON = function () {
    const user = this;
    // console.log('came here');
    const userObject = user.toObject();
    delete userObject.password;
    delete userObject.tokens;
    delete userObject.__v;
    delete userObject.createdAt;
    delete userObject.updatedAt;
    return userObject;
};

userSchema.methods.generateAuthToken = async function () {
    const user = this;
    const token = jwt.sign({ _id: user._id.toString() }, process.env.JWT_SECRET);

    user.tokens = user.tokens.concat({ token: token });
    await user.save();

    return token;
};

userSchema.statics.findByCredentials = async (username, password) => {
    const user = await User.findOne({ username }, { "followers": 0, "following": 0, "likes": 0 });
    if (!user) {
        throw new Error('Wrong Username');
    }
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
        throw new Error('Wrong Password');
    }

    return user;
};



// hash the plain text password before saving
userSchema.pre('save', async function (next) {
    const user = this;

    if (user.isModified('password')) {
        user.password = await bcrypt.hash(user.password, 8);
    }

    next();
});
userSchema.plugin(mongoose_fuzzy_searching, { fields: [{ name: 'username', escapeSpecialCharacters: false }] });
const User = new mongoose.model('User', userSchema);


// (async () => {
//     console.log('hello');
//     // const abc = await User.updateOne({ _id: ObjectId("60d63ce396b7b83c783cc7b4") }, { "$unset": { "username_fuzzy": 1 } });
//     // console.log(abc);
//     // const users = await User.fuzzySearch('vik').select({ _id: 1, username: 1, avatar_url: 1 }).exec();
//     // const users = await User.findById("60d81cf549cef90015bccd00");
//     // users.username_fuzzy = [];
//     // await users.save();
//     // console.log(users.length);
//     // await User.updateMany({}, { $unset: { ['username_fuzzy']: 1 } }, { new: true, strict: false });
//     // const users = await User.find();
//     // for (let user of users) {
//     //     await user.save();
//     // }
//     // const attrs = ['username'];
//     // const cursor = User.find().cursor();
//     // cursor.next(function (error, doc) {
//     //     // const $unset = attrs.reduce((acc, attr) => ({ ...acc, [`${attr}_fuzzy`]: 1 }), {});
//     //     return User.findByIdAndUpdate(doc._id, { $unset: { ['username_fuzzy']: 1 } }, { new: true, strict: false });
//     // });
//     // const users = await User.updateMany({ 'username_fuzzy': { $exists: true, $ne: null } }, { username_fuzzy: null });

// })();


module.exports = User;