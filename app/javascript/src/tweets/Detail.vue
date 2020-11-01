<template>
  <div>
    <div class="flex flex-row mb-4 bg-white shadow sm:rounded-lg">
      <img :src="scaledAvatar(tweet.user.avatar, tweet.user.nickname)" class="inline-block object-cover w-12 h-12 mt-4 ml-4 rounded-full" />
      <div class="w-full p-4 overflow-x-auto">
        <h3 class="text-lg font-medium text-gray-900 leading-6">{{ tweet.user.nickname }}</h3>
        <div class="mt-1 text-sm text-gray-500 leading-5 markdown" v-html="markdown(tweet.body)"></div>
        <TweetOperation class="justify-end mt-8" :tweet="tweet" :currentUser="currentUser" :showTweetComment="noop" :shareTweet="shareTweet" />
        <CommentList :currentUser="currentUser" :tweet="tweet" />
      </div>
    </div>
    <modal name="share-tweet" width="300px" height="auto" background="none">
      <TweetSharer :sharing_tweet="tweet" />
    </modal>
  </div>
</template>
<script>
import LoginDialog from '../common/LoginDialog.vue'
import CommentList from './comments/CommentList'
import TweetSharer from './TweetSharer.vue'
import TweetOperation from './TweetOperation'
import { markdown, scaledAvatar } from '../common/Utils'

export default {
  components: { CommentList, TweetOperation, TweetSharer },
  props: ['origin_tweet'],
  data() {
    return {
      tweet: this.origin_tweet,
      show_comment: true,
      currentUser: window.currentUser(),
    }
  },
  methods: {
    markdown,
    scaledAvatar,
    noop() {},
    shareTweet(tweet) {
      setTimeout(() => {
        this.sharing_tweet = tweet //
        this.$modal.show('share-tweet')
      }, 100)
    },
  },
}
</script>
