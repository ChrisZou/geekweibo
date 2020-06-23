const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  purge: [
    './app/views/layouts/*.html.erb',
    './app/views/**/*.html.erb',
    './app/javascript/**/*.js',
    './app/javascript/**/*.vue',
    './app/helpers/*.rb',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans]
      }
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/ui')
  ]
}
