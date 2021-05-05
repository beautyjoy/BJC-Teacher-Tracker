const webpack = require('webpack')
const { environment } = require('@rails/webpacker')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}))

environment.config.merge({
  module: {
    rules: [
      {
        test: /\.(woff(2)?|ttf|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[path][name].[ext]',
            }
          }
        ]
      },
      // TinyMCE CSS files need to be copied to the js/ path to be loaded correctly.
      {
        test: /tinymce[\\/]skins[\\/]/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: 'js/[path][name].[ext]',
              context: 'node_modules/tinymce'
            }
          }
        ]
      },
    ]
  }
})

module.exports = environment
