<template>
  <div>
    <div class="flex flex-row mb-4 bg-white shadow sm:rounded-lg">
      <img :src="scaledAvatar(tweet.user.avatar, tweet.user.nickname)" class="inline-block object-cover w-12 h-12 mt-4 ml-4 rounded-full" />
      <div class="w-full p-4 overflow-x-auto">
        <h3 class="text-lg font-medium text-gray-900 leading-6">{{ tweet.user.nickname }}</h3>
        <div class="mt-1 text-sm text-gray-500 leading-5 markdown" v-html="markdown(tweet.body)"></div>
        <img
          v-if="tweet.image"
          :src="tweet.image"
          @click="previewImage(tweet.image)"
          class="object-cover max-w-full mt-2 border border-gray-200 rounded-lg max-h-64"
        />
        <TweetOperation class="justify-end mt-8" :tweet="tweet" :currentUser="currentUser" :showTweetComment="noop" :shareTweet="shareTweet" />
        <CommentList :currentUser="currentUser" :tweet="tweet" />
      </div>
    </div>
    <modal name="share-tweet" width="300px" height="auto" background="none">
      <TweetSharer :sharing_tweet="tweet" />
    </modal>
    <modal name="tweet-image" width="800px" height="auto">
      <img :src="previewing_image" class="w-full h-full" alt="" />
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
      previewing_image: '',
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
    previewImage(imageUrl) {
      this.previewing_image = imageUrl
      this.$modal.show('tweet-image')
    },
  },
}
</script>
<style>
.vm--overlay {
  background-color: #000000;
  opacity: 0.7;
}
</style>
