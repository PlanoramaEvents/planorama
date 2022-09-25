const webpackConfig = require('./config/webpack/environment.js').config;
module.exports = {
  components: 'app/javascript/**/*.vue',
  webpackConfig: Object.assign({}, webpackConfig)
}
