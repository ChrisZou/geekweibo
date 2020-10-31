<template>
  <div>
    <div>
      <div class="flex flex-col items-end mt-4">
        <div class="w-full rounded-md shadow-sm">
          <textarea
            v-model="new_tweet"
            rows="3"
            class="block w-full mt-1 form-textarea transition duration-150 ease-in-out sm:text-sm sm:leading-5"
            v-on:keydown.meta.enter="postTweet()"
            v-on:keyup="saveTweetLocally"
            placeholder="学到什么了呢？跟大家分享一下"
          ></textarea>
        </div>
        <button class="mt-2 button" @click.stop="postTweet">
          发布
        </button>
      </div>
    </div>

    <h1 class="mt-4 text-4xl font-medium">最新动态</h1>
    <div id="app" class="mt-8">
      <TweetList :new_tweets="new_tweets" v-bind:tweets_url="tweets_url"></TweetList>
    </div>
  </div>
</template>

<script>
import TweetList from './list.vue'
import LoginDialog from '../common/LoginDialog.vue'
import Vue from 'vue/dist/vue.esm'
import VModal from 'vue-js-modal'
Vue.use(VModal, { dialog: true })

export default {
  components: { TweetList, LoginDialog },
  props: ['tweets', 'tweets_url'],
  mounted() {
    autosize(document.querySelector('textarea'))
  },
  data() {
    return {
      new_tweet: '',
      new_tweets: [],
      loadMore: true,
      currentUser: window.currentUser(),
    }
  },
  methods: {
    loadMoreTweet() {
      console.log('loading more')
    },
    postTweet() {
      if (!this.currentUser) {
        this.$modal.show(LoginDialog, {}, { height: 'auto', width: 400 })
        return
      }

      if (this.new_tweet.trim() === '') return

      post('/tweets', { tweet: { body: this.new_tweet } }).then(data => {
        this.new_tweets.unshift({ user: this.currentUser, body: this.new_tweet })
        localStorage.setItem('new_tweet_backup', '')
      })
    },
    saveTweetLocally() {
      localStorage.setItem('new_tweet_backup', this.new_tweet)
    },
  },
}
</script>
