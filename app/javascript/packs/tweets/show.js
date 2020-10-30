import Vue from 'vue/dist/vue.esm'
import TweetDetail from '../../src/tweets/Detail.vue'
Vue.component('tweet', TweetDetail)

new Vue({ el: '#app' })
