import Vue from 'vue/dist/vue.esm'
import TweetList from '../../src/tweets/list.vue'

Vue.component('tweet-list', TweetList)

new Vue({el: '#app'})
