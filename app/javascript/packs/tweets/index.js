import Vue from 'vue/dist/vue.esm'
import TweetIndex from '../../src/tweets/Index.vue'
import LoginDialog from '../../src/common/login.vue'
import VModal from 'vue-js-modal'


Vue.use(VModal, { dialog: true })
Vue.component('tweet-index', TweetIndex)

new Vue({ el: '#app' })
