const db = require("../models")
const Users = db.user
const jwt = require('jsonwebtoken')
const passwordHash = require('password-hash')
require("dotenv").config()

const register = async (input, res) => {
    try {
        const save = await Users.create(input);
        res.json(save).status(200)
    } catch (error) {
        res.json(error).status(422)
    }
}

const authentication = async (req, res) => {
    try {
        const username = req.body.username.trim();
        const password = req.body.password.trim();
        const cekUsername = await Users.findOne({ where: { username: username } });
        const fetchResult = cekUsername.dataValues
        const verify = passwordHash.verify(password, fetchResult.password);

        if (verify != true) {
            res.json({ msg: 'Password incorect !' }).status(422)
        } else {
            const userToken = {
                id: fetchResult.id,
                username: fetchResult.username
            }

            jwt.sign({ userToken }, process.env.JWT_KEY, {
                expiresIn: '365d' //set exipre token
            }, (err, token) => {
                res.json({ token: token }).status(200)
            });
        }
    } catch (error) {
        res.json({ msg: `username or password not match ${error}` }).status(422);
    }
}

module.exports = {
    register, authentication
}