const { VueLoaderPlugin } = require('vue-loader')
module.exports = {
  module: {
    rules: [
      {
        test: /\.vue/,
        loader: 'vue-loader'
      },
      {
        test: /\.vue(\.erb)?$/,
        loader: 'vue-loader'
      },
      {
        test: /\.scss$/,
        use: [
          'vue-style-loader',
          'css-loader',
          'sass-loader'
        ]
      }
    ]
  },
  plugins: [new VueLoaderPlugin()]
}
