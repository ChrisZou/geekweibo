<template>
  <div class="flex items-center">
    <svg
      fill="none"
      class="w-7 h-7 p-1.5 cursor-pointer hover:bg-gray-200 rounded-full transition duration-300"
      viewBox="0 0 24 24"
      stroke="currentColor"
      aria-label="share icon"
      @click="shareTweet(tweet)"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"
      />
    </svg>

    <svg
      fill="none"
      class="p-1.5 rounded-full cursor-pointer w-7 h-7 hover:bg-gray-200 transition duration-300 ml-7"
      stroke-width="2"
      viewBox="0 0 24 24"
      stroke="currentColor"
      aria-label="comment icon"
      @click.stop="showTweetComment(tweet)"
    >
      <path
        d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
      />
    </svg>
    <div class="w-4">
      <span class="inline-block ml-0.5 text-xs" v-show="tweet.comments.length">{{ tweet.comments.length }}</span>
    </div>
    <svg
      viewBox="0 0 24 24"
      class="w-7 h-7 p-1.5 hover:bg-gray-200 transition duration-300 rounded-full ml-3 cursor-pointer fill-current"
      :class="tweet.liked ? 'text-red-500' : 'text-black'"
      aria-label="like icon"
      @click.stop="toggleLike(tweet)"
    >
      <path
        class="heroicon-ui"
        d="M12.76 3.76a6 6 0 018.48 8.48l-8.53 8.54a1 1 0 01-1.42 0l-8.53-8.54a6 6 0 018.48-8.48l.76.75.76-.75zm7.07 7.07a4 4 0 10-5.66-5.66l-1.46 1.47a1 1 0 01-1.42 0L9.83 5.17a4 4 0 10-5.66 5.66L12 18.66l7.83-7.83z"
      />
    </svg>
    <div class="w-4">
      <span :class="tweet.liked ? 'text-red-500' : 'text-black'" v-if="tweet.like_count" class="inline-block ml-0.5 text-xs">
        {{ tweet.like_count }}
      </span>
    </div>
  </div>
</template>

<script>
import LoginDialog from '../common/LoginDialog.vue'
export default {
  props: ['tweet', 'currentUser', 'showTweetComment', 'shareTweet'],
  data() {
    return {}
  },
  methods: {
    toggleLike(tweet) {
      if (!this.currentUser) {
        this.showLoginDialog()
        return
      }

      const action = tweet.liked ? window.delete : window.post
      action('/likes', {
        likable_id: tweet.id,
        likable_type: 'Tweet',
      }).then(res => console.log('like/unlike succeed'))

      tweet.liked = !tweet.liked
      tweet.like_count += tweet.liked ? 1 : -1
    },
    showLoginDialog() {
      this.$modal.show(LoginDialog, {}, { height: 'auto', width: 400 })
    },
  },
}
</script>

<style>
</style>
