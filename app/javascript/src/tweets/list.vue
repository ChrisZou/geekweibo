<template>
  <div id="tweet-list">
    <div class="flex flex-row mb-4 bg-white shadow sm:rounded-lg" v-for="tweet in allTweets" :key="tweet.id">
      <a :href="`/users/${tweet.user.id}`">
        <img
          :src="scaledAvatar(tweet.user.avatar, tweet.user.nickname)"
          class="inline-block object-cover w-12 h-12 mt-4 ml-4 bg-gray-500 rounded-full"
        />
      </a>
      <div class="relative w-full p-4 overflow-x-auto">
        <h3 class="text-lg font-medium text-gray-900 leading-6">{{ tweet.user.nickname }}</h3>
        <div
          v-if="tweet.question && tweet.show_question"
          class="mt-4 text-lg font-medium text-center text-indigo-400 cursor-pointer leading-5 "
          @click="showBody(tweet)"
          v-html="markdown(tweet.question)"
        />
        <div v-else class="mt-1 text-sm text-gray-500 leading-5 markdown" v-html="markdown(tweet.body)" />
        <div v-if="isMyTweet(tweet)" class="absolute top-1 right-1">
          <v-popover>
            <svg class="w-6 h-6 p-1 rounded-full hover:bg-gray-200 right-2 top-2 transition duration-300" viewBox="0 0 20 20">
              <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
            </svg>
            <template slot="popover">
              <div
                class="flex flex-col items-center py-1 bg-white border border-gray-100 border-solid rounded-sm focus:outline-none active:outline-none"
              >
                <span
                  class="w-full px-8 py-2 text-sm tracking-wider text-center border-b border-gray-100 cursor-pointer hover:bg-gray-200 transition duration-300 active:outline-none"
                  @click="setQuestionForTweet(tweet)"
                  v-text="'设置问题'"
                />
                <span
                  class="w-full px-8 py-2 text-sm tracking-wider text-center cursor-pointer hover:bg-gray-200 transition duration-300 active:outline-none"
                  @click="confirmDeleteTweet(tweet)"
                  v-text="'删除'"
                />
              </div>
            </template>
          </v-popover>
        </div>
        <img
          v-if="tweet.image"
          :src="tweet.image"
          @click="previewImage(tweet.image)"
          class="object-cover max-w-full mt-2 border border-gray-200 rounded-lg max-h-64"
        />
        <div aria-label="tweet operations" class="flex items-center justify-end mt-4">
          <TweetOperation :tweet="tweet" :currentUser="currentUser" :showTweetComment="showTweetComment" :shareTweet="shareTweet" />
        </div>
        <CommentList v-if="tweet.show_comment" :currentUser="currentUser" :tweet="tweet" />
      </div>
    </div>
    <Loading v-show="loading_more" />
    <v-dialog />
    <modal name="tweet-image" width="800px" height="auto">
      <img :src="previewing_image" class="w-full h-full" alt="" />
    </modal>
    <modal name="share-tweet" width="300px" height="auto" background="none">
      <TweetSharer :sharing_tweet="sharing_tweet" />
    </modal>
  </div>
</template>

<script>
import LoginDialog from '../common/LoginDialog.vue'
import Loading from '../common/Loading.vue'
import CommentList from './comments/CommentList.vue'
import TweetSharer from './TweetSharer.vue'
import TweetOperation from './TweetOperation.vue'
import SetTweetQuestionDialog from './SetTweetQuestionDialog.vue'

import { VPopover } from 'v-tooltip'
import Vue from 'vue/dist/vue.esm'
import VModal from 'vue-js-modal'
Vue.use(VModal, { dialog: true })

import { markdown, scaledAvatar } from '../common/Utils.js'

export default {
  components: { 'v-popover': VPopover, CommentList, Loading, TweetSharer, TweetOperation },
  props: ['tweets', 'tweets_url', 'new_tweets'],
  data() {
    return {
      items: [],
      page: 1,
      currentUser: window.currentUser(),
      loading_more: false,
      has_more: true,
      sharing_tweet: null,
      previewing_image: '',
    }
  },
  computed: {
    allTweets() {
      return this.new_tweets ? this.new_tweets.concat(this.items) : this.items
    },
  },
  methods: {
    urlWithPage() {
      return this.tweets_url + (this.tweets_url.includes('?') ? '&' : '?') + 'page=' + this.page
    },
    loadMoreTweet() {
      if (this.loading_more) return
      if (!this.has_more) return

      this.loading_more = true
      const url = this.urlWithPage()
      get(url).then(tweets => {
        this.loading_more = false
        tweets.data.forEach(t => {
          t.has_more_comments = t.comments.length > 5
          t.comments = t.comments.slice(0, 5)
          t.replying_comment = null
          t.show_question = this.isMyTweet(t)
        })
        this.items = this.items.concat(tweets.data)
        this.has_more = tweets.has_more
        this.page = this.page + 1
      })
    },
    showLoginDialog() {
      this.$modal.show(LoginDialog, {}, { height: 'auto', width: 400 })
    },
    showTweetComment(tweet) {
      if (!sessionStorage.getItem('loggedIn')) {
        this.showLoginDialog()
        return
      }

      this.items = this.items.map(t => {
        if (t.id == tweet.id) {
          t.show_comment = true
        }
        return t
      })
      tweet.show_comment = true
    },
    shareTweet(tweet) {
      window.scrollTo(0, 0)
      setTimeout(() => {
        this.sharing_tweet = tweet //
        this.$modal.show('share-tweet')
      }, 100)
    },
    confirmDeleteTweet(tweet) {
      this.$modal.show('dialog', {
        title: '确定删除这条推文？',
        text: '推文一旦删除，将无法恢复',
        buttons: [
          {
            title: '取消',
            class: 'focus:outline-none py-3 hover:bg-gray-100 ',
            handler: () => {
              this.$modal.hide('dialog')
            },
          },
          {
            title: '确定',
            default: true,
            class: 'focus:outline-none py-3 hover:bg-gray-100',
            handler: () => {
              this.$modal.hide('dialog')
              window.delete(`/tweets/${tweet.id}`).then(() => {
                const newTweetIndex = this.new_tweets.findIndex((t) => t.id === tweet.id)
                if (newTweetIndex !== -1) {
                  this.new_tweets.splice(newTweetIndex, 1)
                } else {
                  this.items = this.items.filter(t => t.id !== tweet.id)
                }
              })
            },
          },
        ],
      })
    },
    setQuestionForTweet(tweet) {
      this.$modal.show(
          SetTweetQuestionDialog,
          {
            tweet: tweet,
            onComplete: () => {
              this.$modal.hide('set-question')
            },
          },
          { name: 'set-question', height: 'auto' }
      )
    },
    isMyTweet(tweet) {
      return this.currentUser && this.currentUser.id == tweet.user.id
    },
    isMyComment(comment) {
      return this.currentUser && this.currentUser.id == comment.user.id
    },
    commentContent(comment) {
      if (comment.parent_comment) {
        return `@${comment.parent_comment.user.nickname} ${comment.body}`
      } else {
        return comment.body
      }
    },
    markdown: markdown,
    scaledAvatar: scaledAvatar,
    previewImage(imageUrl) {
      this.previewing_image = imageUrl
      this.$modal.show('tweet-image')
    },
    showBody(tweet) {
      tweet.show_question = false
    },
  },
  mounted() {
    // Detect when scrolled to bottom.
    window.addEventListener('scroll', e => {
      const bottom = document.documentElement.scrollTop + window.innerHeight > document.documentElement.offsetHeight - 50
      if (bottom) {
        this.loadMoreTweet()
      }
    })

    // Initially load some items.
    this.loadMoreTweet()
  },
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
<style>
.vm--overlay {
  background-color: #000000;
  opacity: 0.7;
}
</style>
