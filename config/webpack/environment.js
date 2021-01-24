const { webpackConfig, merge } = require('@rails/webpacker')
const vueConfig = require('./loaders/vue')
const customConfig = {
    resolve: {
        extensions: ['.css', '.scss']
    }
}

module.exports = merge(vueConfig, webpackConfig, customConfig)
