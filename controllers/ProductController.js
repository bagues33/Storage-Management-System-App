const { product } = require('../models');

class ProductController {
    static getAllProducts(req, res) {
        product.findAll()
            .then((products) => {
                res.status(200).json(products);
            })
            .catch((err) => {
                res.status(500).json(err);
            });
    }

    static getProduct(req, res) {
        product.findByPk(req.params.id)
            .then((product) => {
                res.status(200).json(product);
            })
            .catch((err) => {
                res.status(500).json(err);
            });
    }

    static createProduct(req, res) {
        product.create({
            name: req.body.name,
            qty: req.body.qty,
            image_url: req.body.image_url,
            created_by: req.body.created_by,
            updated_by: req.body.updated_by,
            category_id: req.body.category_id
        })
        .then((product) => {
            res.status(201).json(product);
        })
        .catch((err) => {
            res.status(500).json(err);
        });
    }

    static updateProduct(req, res) {
        product.update({
            name: req.body.name,
            qty: req.body.qty,
            image_url: req.body.image_url,
            created_by: req.body.created_by,
            updated_by: req.body.updated_by,
            category_id: req.body.category_id
        }, {
            where: {
                id: req.params.id
            }
        })
        .then((product) => {
            res.status(200).json(product);
        })
        .catch((err) => {
            res.status(500).json(err);
        });
    }

    static deleteProduct(req, res) {
        product.destroy({
            where: {
                id: req.params.id
            }
        })
        .then((product) => {
            res.status(200).json(product);
        })
        .catch((err) => {
            res.status(500).json(err);
        });
    }
    
}

module.exports = ProductController;