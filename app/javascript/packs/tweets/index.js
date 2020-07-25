import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import TweetList from '../../src/tweets/list.vue'
import LoginDialog from '../../src/common/login.vue'

Vue.use(TurbolinksAdapter)

Vue.component('tweet-list', TweetList)
Vue.component('login-dialog', LoginDialog)

document.addEventListener('turbolinks:load', () => {
  new Vue({
    el: '#app'
  })
})
