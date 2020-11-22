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
    }
  },
  variants: {
    extend: {
      // ...
      backgroundColor: ['active'],
      // border: ['active'],
    }
  },
  experimental: {
    applyComplexClasses: true,
  },
  plugins: [
    require('@tailwindcss/forms')
  ]
}
