import Vue from 'vue/dist/vue.esm'
import TweetDetail from '../../src/tweets/Detail.vue'
import VModal from 'vue-js-modal'

Vue.use(VModal)
Vue.component('tweet', TweetDetail)

new Vue({ el: '#app' })
