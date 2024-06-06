const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const routes = require('./routes');
app.use('/api', routes);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});