Sequelize = require 'sequelize'
sequelize = Sequelize.sequelize

sequelize.define 'article',
    title:
      type: Sequelize.STRING

    html:
      type: Sequelize.STRING

    date:
      type: Sequelize.DATE

    active:
      type: Sequelize.BOOLEAN
      defaultValue: false

module.exports = sequelize.models

