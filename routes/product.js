const productRoutes = require('express').Router();
const ProductController = require('../controllers/ProductController');

productRoutes.get('/', ProductController.getAllProducts);
productRoutes.get('/:id', ProductController.getProduct);
productRoutes.post('/', ProductController.createProduct);
productRoutes.put('/:id', ProductController.updateProduct);
productRoutes.delete('/:id', ProductController.deleteProduct);

module.exports = productRoutes;
