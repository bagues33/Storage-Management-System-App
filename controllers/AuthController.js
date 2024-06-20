const { user } = require("../models")
const jwt = require('jsonwebtoken')
const passwordHash = require('password-hash')
const fs = require('fs')
const path = require('path')
require("dotenv").config()

class AuthController {

    static async register(input, res) {
        try {
            const userExists = await user.findOne({ where: { username: input.username } });
            if (userExists) {
                return res.status(422).json({ error: 'Username already exists' });
            }

            const save = await user.create(input);
            res.json(save).status(200)
        } catch (error) {
            res.json(error).status(422)
        }
    }

    static async authentication(req, res) {
        try {
            const username = req.body.username.trim();
            const password = req.body.password.trim();
            const cekUsername = await user.findOne({ where: { username: username } });
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
            console.log("Error login : ", error);
            res.json({ msg: `username or password not match` }).status(422);
        }
    }

    static async updateProfile(req, res) {
        try {
            const id = req.body.id
            const username = req.body.username
            const password = req.body.password
            const image_name = req.file ? req.file.filename : undefined 

            const passwordToSave = password ? passwordHash.generate(password) : undefined; 

            const userData = await user.findByPk(id);

            if (userData.image && image_name) {
                fs.unlinkSync(path.join(__dirname, `../public/uploads/users/${userData.image}`));
            }

            const newData = {
                username: username,
            };

            if (image_name) {
                newData.image = image_name;
            }

            if (passwordToSave) {
                newData.password = passwordToSave;
            }

            const update = await user.update(newData, { where: { id: id } });

            res.json(update).status(200)
        } catch (error) {
            res.json(error).status(422)
        }
    }

    static async getUser(req, res) {
        try {
            const id = req.params.id
            console.log("id : ", id);
            const userData = await user.findOne({ where: { id: id } })
            res.json(userData).status(200)
        }
        catch (error) {
            res.json(error).status(422)
        }
    }
}

module.exports = AuthController;