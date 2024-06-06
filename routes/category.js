const categoryRoutes = require('express').Router();
const CategoryController = require('../controllers/CategoryController');

categoryRoutes.get('/', CategoryController.getAllCategories);
categoryRoutes.get('/:id', CategoryController.getCategory);
categoryRoutes.post('/', CategoryController.createCategory);
categoryRoutes.put('/:id', CategoryController.updateCategory);
categoryRoutes.delete('/:id', CategoryController.deleteCategory);

module.exports = categoryRoutes;