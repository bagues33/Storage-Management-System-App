'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class product extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      product.belongsTo(models.category, {
        foreignKey: 'category_id',
        as: 'category',
        onDelete: 'CASCADE',
      });
      product.belongsTo(models.user, {
        foreignKey: 'created_by',
        as: 'createdBy',
        onDelete: 'CASCADE',
      });
      product.belongsTo(models.user, {
        foreignKey: 'updated_by',
        as: 'updatedBy',
        onDelete: 'CASCADE',
      });
    }
  }
  product.init({
    name: DataTypes.STRING,
    qty: DataTypes.INTEGER,
    image_url: DataTypes.STRING,
    created_by: DataTypes.INTEGER,
    updated_by: DataTypes.INTEGER,
    category_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'product',
  });
  return product;
};