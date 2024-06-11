const productRoutes = require('express').Router();
const ProductController = require('../controllers/ProductController');
const { check } = require('express-validator');

const checkValidation = [
    check('name').isLength({ min: 3 }).withMessage('Name must be at least 3 characters long'),
    check('qty').isNumeric().withMessage('Qty must be a number'),
    check('image_url').isURL().withMessage('Image URL must be a valid URL'),
    check('created_by').isNumeric(),
    check('updated_by').isNumeric(),
    check('category_id').isNumeric(),
];

const checkValidationEdit = [
    check('name').isLength({ min: 3 }).withMessage('Name must be at least 3 characters long'),
    check('qty').isNumeric().withMessage('Qty must be a number'),
    check('image_url').isURL().withMessage('Image URL must be a valid URL'),
    check('updated_by').isNumeric(),
    check('category_id').isNumeric(),
];

productRoutes.get('/', ProductController.getAllProducts);
productRoutes.get('/:id', ProductController.getProduct);
productRoutes.post('/', checkValidation, ProductController.createProduct);
productRoutes.put('/:id', checkValidationEdit, ProductController.updateProduct);
productRoutes.delete('/:id', ProductController.deleteProduct);

module.exports = productRoutes;
