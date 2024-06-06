const route = require('express').Router();

route.get('/', (req, res) => {
    res.send('Hello World!');
});

const categoryRoutes = require('./category');
const productRoutes = require('./product');
const authRoutes = require('./auth');

route.use('/products', productRoutes);
route.use('/auth', authRoutes);
route.use('/categories', categoryRoutes);

module.exports = route;