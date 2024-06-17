const db = require("../models")
const Users = db.user
const jwt = require('jsonwebtoken')
const passwordHash = require('password-hash')
require("dotenv").config()

const register = async (input, res) => {
    try {
        // Check if the username already exists
        const userExists = await Users.findOne({ where: { username: input.username } });
        if (userExists) {
            return res.status(422).json({ error: 'Username already exists' });
        }

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
                res.status(200).json({ user: userToken, token: token })
            });
        }
    } catch (error) {
        res.json({ msg: `username or password not match` }).status(422);
    }
}

const updateProfile = async (req, res) => {
    try {
        const id = req.body.id
        const username = req.body.username
        const password = req.body.password
        const image_name = req.file ? req.file.filename : null
        const passwordToSave = passwordHash.generate(password)
        const data = {
            username: username.trim(),
            password: passwordToSave,
            image: image_name,
        }

        const update = await Users.update(data, { where: { id: id } });
        res.json(update).status(200)
    } catch (error) {
        res.json(error).status(422)
    }
}

const getUser = async (req, res) => {
    try {
        const id = req.params.id
        const user = await Users.findOne({ where: { id: id } })
        res.json(user).status(200)
    }
    catch (error) {
        res.json(error).status(422)
    }
}

module.exports = {
    register, authentication, updateProfile, getUser
}