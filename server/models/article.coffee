module.exports = (sequelize, DataTypes) ->
  attributes =
    title:
      type: DataTypes.STRING

    html:
      type: DataTypes.STRING

    date:
      type: DataTypes.DATE

    active:
      type: DataTypes.BOOLEAN
      defaultValue: false

  Article = sequelize.define('article', attributes)

  return Article