import Vue from 'vue/dist/vue.esm'
import TweetIndex from '../../src/tweets/Index.vue'
import LoginDialog from '../../src/common/login.vue'


Vue.component('tweet-index', TweetIndex)

new Vue({ el: '#app' })
