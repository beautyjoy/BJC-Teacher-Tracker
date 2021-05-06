const webpack = require('webpack')
const { environment } = require('@rails/webpacker')
const env = require('@rails/webpacker/package/env')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}))

// This is a hack!!
// We need to exclude the tinymce CSS files from the CSS loader.
let loader;
for (num in environment.loaders) {
  loader = environment.loaders[num];
  if (loader.key === 'css') {
    loader.value.exclude = /.*skin.*/;
  }
}

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

console.log(environment.loaders)
module.exports = environment
