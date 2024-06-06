const express = require('express')
const auth = require('../controllers/AuthController')
const { check, validationResult } = require('express-validator')
const passwordHash = require('password-hash') 
const router = express.Router()
const uploadUser = require('../middlewares/upload-product')

const checkValidation = [
    check('username').not().isEmpty().withMessage('required value').isAlphanumeric(),
    check('password').not().isEmpty().withMessage('required value').isAlphanumeric(),
];

const checkValidationLogin = [
    check('username').not().isEmpty().withMessage('required value').isAlphanumeric(),
    check('password').not().isEmpty().withMessage('required value').isAlphanumeric(),
];

const postParam = (req) => {
    const passwordToSave = passwordHash.generate(req.body.password)
    const image_name = req.file ? req.file.filename : null,
        data = {
            username: req.body.username.trim(),
            password: passwordToSave,
            image: image_name,
        };
    return data;
}

router.post(`/register`, [uploadUser.single('image'), checkValidation], (req, res) =>  {
    const errors = validationResult(req);
    (!errors.isEmpty() ? res.status(422).json(errors) : auth.register(postParam(req), res))
})
router.post(`/login`, [checkValidationLogin], (req, res) => {
     const errors = validationResult(req);
     (!errors.isEmpty() ? res.status(422).json(errors) : auth.authentication(req, res))
})

module.exports = router