const categoryRoutes = require('express').Router();
const CategoryController = require('../controllers/CategoryController');
const { check } = require('express-validator');

const checkValidation = [
    check('name').isLength({ min: 3 }).withMessage('Name must be at least 3 characters long'),
];

categoryRoutes.get('/', CategoryController.getAllCategories);
categoryRoutes.get('/:id', CategoryController.getCategory);
categoryRoutes.post('/', checkValidation, CategoryController.createCategory);
categoryRoutes.put('/:id', checkValidation, CategoryController.updateCategory);
categoryRoutes.delete('/:id', CategoryController.deleteCategory);

module.exports = categoryRoutes;