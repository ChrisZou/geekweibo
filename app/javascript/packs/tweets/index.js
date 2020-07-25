import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import TweetIndex from '../../src/tweets/Index.vue'
import LoginDialog from '../../src/common/login.vue'

Vue.use(TurbolinksAdapter)

Vue.component('tweet-index', TweetIndex)

document.addEventListener('turbolinks:load', () => {
  new Vue({
    el: '#app'
  })
})
