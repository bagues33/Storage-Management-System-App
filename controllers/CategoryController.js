const { category } = require('../models');
const { validationResult } = require('express-validator')

class CategoryController {
    static getAllCategories(req, res) {
        category.findAll()
            .then((categories) => {
                res.status(200).json(categories);
            })
            .catch((err) => {
                res.status(500).json(err);
            });
    }

    static getCategory(req, res) {
        category.findByPk(req.params.id)
            .then((category) => {
                res.status(200).json(category);
            })
            .catch((err) => {
                res.status(500).json(err);
            });
    }

    static createCategory(req, res) {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json(errors.array());
        }

        category.create({
            name: req.body.name
        })
        .then((category) => {
            res.status(201).json(category);
        })
        .catch((err) => {
            res.status(500).json(err);
        });
    }

    static updateCategory(req, res) {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json(errors.array());
        }

        category.update({
            name: req.body.name
        }, {
            where: {
                id: req.params.id
            }
        })
        .then((category) => {
            res.status(200).json(category);
        })
        .catch((err) => {
            res.status(500).json(err);
        });
    }

    static deleteCategory(req, res) {
        category.destroy({
            where: {
                id: req.params.id
            }
        })
        .then((category) => {
            res.status(200).json(category);
        })
        .catch((err) => {
            res.status(500).json(err);
        });
    }
}

module.exports = CategoryController;