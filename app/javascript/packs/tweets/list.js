import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import App from '../../src/tweets/list.vue'

Vue.use(TurbolinksAdapter)

Vue.component('app', App)

document.addEventListener('turbolinks:load', () => {
  new Vue({el: '#app'})
})
