const webpack = require("webpack");
const { environment } = require("@rails/webpacker");

environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    Popper: ["popper.js", "default"],
  })
);

environment.config.merge({
  module: {
    rules: [
      {
        test: /\.(svg|eot|woff|woff2|ttf)$/,
        use: [
          {
            loader: "file-loader?name=[path][name].[ext]",
            options: {
              name: '[path][name].[ext]',
            }
          }
        ],
      },
    ],
  },
});

module.exports = environment;
