const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Rails: '@rails/ujs',
    Popper: ['popper.js', 'default']
  })
)

module.exports = environment
