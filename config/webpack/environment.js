const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const erb = require('./loaders/erb')

const webpack = require('webpack')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.loaders.prepend('erb', erb)

// added and allow BootstrapVue to work.
const config = environment.toWebpackConfig()
config.resolve = {
    alias: {
        'vue$': 'vue/dist/vue.esm.js'
    },
    extensions: ['*', '.js', '.vue', '.json']
},

module.exports = environment
