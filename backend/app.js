require('dotenv').config();
require('./Database/database');
const PORT = process.env.PORT || 3000;
const express = require('express');
const cors = require('cors');
const app = express();
const userRouter = require('./Routers/user');
const muralRouter = require('./Routers/mural');
const errorHandler = require('./Middleware/ErrorHandler');
app.use(express.json());
app.use(cors());
app.use(userRouter);
app.use(muralRouter);
app.use(errorHandler);

app.listen(PORT, () => {
    console.log(`App running on Port ${PORT}`);
});