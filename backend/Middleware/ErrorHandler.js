module.exports = (err, req, res, next) => {
    console.log('*******', 'came here');
    console.log(err.code);
    if (err.code === 11000 && err.name === 'MongoError') {
        res.statusCode = 400;
        return res.json({ msg: 'Duplicate Username Provided' });
    }
    if (err.name === 'ValidationError') {
        res.statusCode = 400;
        return res.json({ message: err.message });
    }
    console.log(err);
    err.msg = 'Something Went Wrong';
    res.statusCode = 500 || err.statusCode;
    res.json(err);
}