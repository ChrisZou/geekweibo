<template>
  <div id="tweet-list">
    <div class="flex flex-row mb-4 bg-white shadow sm:rounded-lg" v-for="(tweet, index) in items" :key="tweet.id">
      <a :href="`/users/${tweet.user.id}`">
        <img
          :src="scaledAvatar(tweet.user.avatar, tweet.user.nickname)"
          class="inline-block object-cover w-12 h-12 mt-4 ml-4 bg-gray-500 rounded-full"
        />
      </a>
      <div class="relative w-full p-4 overflow-x-auto">
        <h3 class="text-lg font-medium text-gray-900 leading-6">{{ tweet.user.nickname }}</h3>
        <div stroke="currentColor" class="mt-1 text-sm text-gray-500 leading-5 markdown" v-html="markdown(tweet.body)"></div>
        <div class="absolute top-1 right-1">
          <v-popover>
            <svg v-if="isMyTweet(tweet)" class="w-6 h-6 p-1 rounded-full hover:bg-gray-200 right-2 top-2 transition duration-300" viewBox="0 0 20 20">
              <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
            </svg>
            <template slot="popover">
              <div class="flex items-center py-1 bg-white border border-gray-100 border-solid rounded-sm focus:outline-none active:outline-none">
                <span
                  class="px-8 py-2 text-sm tracking-wider cursor-pointer hover:bg-gray-200 transition duration-300 active:outline-none"
                  @click="confirmDeleteTweet(tweet)"
                  >删除</span
                >
              </div>
            </template>
          </v-popover>
        </div>
        <div class="flex items-center justify-between mt-4">
          <span class="text-xs text-gray-500">{{ tweet.created_at }}</span>
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
            <span :class="tweet.liked ? 'text-red-500' : 'text-black'" v-if="tweet.like_count" class="inline-block ml-0.5 text-xs">{{
              tweet.like_count
            }}</span>
          </div>
        </div>
        <div v-if="tweet.show_comment" class="mt-2 rounded">
          <div class="flex flex-col p-3 bg-gray-100 rounded">
            <div class="flex flex-row">
              <img v-if="currentUser" :src="currentUser.avatar" class="object-cover w-8 h-8 rounded-full" />
              <div class="flex flex-col w-full ml-3">
                <div
                  contenteditable="true"
                  v-bind:ref="'tweet_comment_inbox_' + index"
                  v-html="tweet.new_comment"
                  @input="e => updateNewCommentOf(e, tweet)"
                  class="w-full p-2 bg-white border-indigo-100 border-solid rounded outline-none"
                  v-on:keydown.meta.enter="postComment(tweet, index)"
                ></div>
                <div class="flex items-center justify-between">
                  <div class="flex items-center">
                    <span v-if="tweet.replying_comment" class="text-sm text-gray-600">
                      回复 @{{ tweet.replying_comment.user.nickname }}: {{ tweet.replying_comment.body }}
                    </span>
                  </div>
                  <button
                    @click="postComment(tweet, index)"
                    class="self-end px-3 py-2 mt-2 text-xs text-white bg-indigo-500 rounded outline-none focus:outline-none active:bg-indigo-600"
                  >
                    评论
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div v-for="comment in tweet.comments" class="flex flex-row mt-3 ml-3" v-bind:key="comment.id">
            <img :src="scaledAvatar(comment.user.avatar, comment.user.nickname)" class="object-cover w-8 h-8 rounded-full" />
            <div class="w-full ml-2">
              <div class="flex items-center justify-between">
                <div class="text-xs font-medium text-gray-900">{{ comment.user.nickname }}</div>
                <svg
                  class="w-5 h-5 p-1 text-gray-400 rounded-full hover:bg-gray-200 transition duration-300"
                  aria-label="delete comment"
                  v-if="isMyComment(comment)"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                  @click="confirmDeleteComment(tweet, comment)"
                >
                  <path
                    fill-rule="evenodd"
                    d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                    clip-rule="evenodd"
                  />
                </svg>
              </div>
              <div
                class="text-sm text-gray-500 cursor-pointer markdown"
                @click="tweet.replying_comment = tweet.replying_comment ? null : comment"
                v-html="commentContent(comment)"
              ></div>
            </div>
          </div>
          <a
            v-if="tweet.has_more_comment"
            :href="`/tweets/${tweet.id}`"
            class="inline-block w-full pt-3 mt-3 text-sm text-center border-t border-gray-200"
            >查看更多&nbsp;&gt;</a
          >
        </div>
      </div>
    </div>
    <div v-show="loading_more" class="w-full text-center">
      <div class="lds-ellipsis">
        <div></div>
        <div></div>
        <div></div>
        <div></div>
      </div>
    </div>
    <v-dialog />
    <modal name="share-tweet" width="300px" height="auto" background="none">
      <div class="flex flex-col items-center">
        <div v-if="sharing_tweet" id="sharing-image-root" class="flex flex-col w-full bg-white">
          <div class="flex flex-row items-center pb-4 mt-4 bg-white border-b border-gray-200">
            <a :href="`/users/${sharing_tweet.user.id}`">
              <img
                :src="scaledAvatar(sharing_tweet.user.avatar, sharing_tweet.user.nickname, Math.random())"
                crossorigin="geekweibo.com"
                class="inline-block object-cover w-10 h-10 ml-4 bg-gray-500 rounded-full"
              />
            </a>
            <h3 class="ml-2 text-lg text-gray-900 leading-6">{{ sharing_tweet.user.nickname }}</h3>
          </div>
          <div stroke="currentColor" class="p-4 pb-0 text-sm text-gray-500 leading-5 markdown" v-html="markdown(sharing_tweet.body)"></div>
          <qrcode :value="`https://geekweibo.com/tweets/${sharing_tweet.id}`" class="self-center mb-0" :options="{ width: 150 }"></qrcode>
          <span class="self-center mb-4 text-gray-600">geekweibo.com</span>
        </div>
        <svg class="w-8 h-8 mb-4" @click="downloadSharingImage" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
        </svg>
      </div>
    </modal>
  </div>
</template>

<script>
import { VPopover } from 'v-tooltip'
import LoginDialog from '../common/LoginDialog.vue'
import Vue from 'vue/dist/vue.esm'
import VueQrcode from '@chenfengyuan/vue-qrcode'
import VModal from 'vue-js-modal'
import html2canvas from 'html2canvas'
Vue.component(VueQrcode.name, VueQrcode)
Vue.use(VModal, { dialog: true })

const marked = require('marked')
marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  breaks: true,
  pedantic: false,
  smartLists: true,
  smartypants: false,
})

export default {
  components: { 'v-popover': VPopover },
  props: ['tweets', 'tweets_url'],
  data() {
    return {
      items: [],
      page: 1,
      currentUser: window.currentUser(),
      loading_more: false,
      has_more: true,
      sharing_tweet: null,
    }
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
        tweets.data.forEach(t => (t.replying_comment = null))
        if (this.page > 1) {
          this.items = this.items.concat(tweets.data)
        } else {
          this.items = tweets.data
        }
        this.has_more = tweets.has_more
        this.page = this.page + 1
      })
    },
    showMenuForTweetItem(tweet) {
      tweet.showMenu = !tweet.showMenu
    },
    toggleLike(tweet) {
      if (!sessionStorage.getItem('loggedIn')) {
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
    showTweetComment(tweet) {
      if (!sessionStorage.getItem('loggedIn')) {
        this.showLoginDialog()
        return
      }

      // show comment modal
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
        this.$modal.show('share-tweet', {}, { resizable: true, classes: 'w-10' })
      }, 100)
    },
    updateNewCommentOf(e, tweet) {
      tweet.new_comment = e.target.innerText
    },
    postComment(tweet, index) {
      if (!tweet.new_comment) return

      post('/comments', {
        tweet_id: tweet.id,
        body: tweet.new_comment,
        parent_comment_id: tweet.replying_comment ? tweet.replying_comment.id : null,
      }).then(data => {
        tweet.comments.unshift({
          user: this.currentUser,
          body: data.body,
          parent_comment: tweet.replying_comment,
        })
        tweet.replying_comment = null
        tweet.new_comment = ''
        this.$refs['tweet_comment_inbox_' + index][0].innerText = ''
      })
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
              window.delete(`/tweets/${tweet.id}`).then(res => {
                this.items = this.items.filter(t => t.id != tweet.id)
              })
            },
          },
        ],
      })
    },
    confirmDeleteComment(tweet, comment) {
      this.$modal.show('dialog', {
        title: '确定删除这条评论？',
        text: '此操作无法撤销',
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
              window.delete(`/comments/${comment.id}`).then(res => {
                tweet.comments = tweet.comments.filter(c => c.id != comment.id)
              })
            },
          },
        ],
      })
    },
    isMyTweet(tweet) {
      return this.currentUser && this.currentUser.id == tweet.user.id
    },
    isMyComment(comment) {
      return this.currentUser && this.currentUser.id == comment.user.id
    },
    scaledAvatar(avatar, nickname, timestamps) {
      if (!timestamps) timestamps = 0
      return avatar
        ? `${avatar}?x-oss-process=image/resize,m_fill,h_100,w_100&s=${timestamps}`
        : `https://ui-avatars.com/api/?background=444444&name=${nickname}&length=1&color=eeeeee`
    },
    commentContent(comment) {
      if (comment.parent_comment) {
        return `@${comment.parent_comment.user.nickname} ${comment.body}`
      } else {
        return comment.body
      }
    },
    markdown(body) {
      return marked(body)
    },
    downloadSharingImage() {
      html2canvas(document.querySelector('#sharing-image-root'), { useCORS: true, imageTimeout: 2000 }).then(canvas => {
        const img = document.createElement('a')
        img.href = canvas.toDataURL('image/jpeg').replace('image/jpeg', 'image/octet-stream')
        img.download = `${this.sharing_tweet.id}.jpg`
        img.click()
      })
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

.angle {
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 0 10px 10px 10px;
  border-color: transparent transparent #f4f5f7 transparent;
}

.lds-ellipsis {
  display: inline-block;
  position: relative;
  width: 80px;
  height: 80px;
}
.lds-ellipsis div {
  position: absolute;
  top: 33px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: #999;
  animation-timing-function: cubic-bezier(0, 1, 1, 0);
}
.lds-ellipsis div:nth-child(1) {
  left: 8px;
  animation: lds-ellipsis1 0.6s infinite;
}
.lds-ellipsis div:nth-child(2) {
  left: 8px;
  animation: lds-ellipsis2 0.6s infinite;
}
.lds-ellipsis div:nth-child(3) {
  left: 32px;
  animation: lds-ellipsis2 0.6s infinite;
}
.lds-ellipsis div:nth-child(4) {
  left: 56px;
  animation: lds-ellipsis3 0.6s infinite;
}
@keyframes lds-ellipsis1 {
  0% {
    transform: scale(0);
  }
  100% {
    transform: scale(1);
  }
}
@keyframes lds-ellipsis3 {
  0% {
    transform: scale(1);
  }
  100% {
    transform: scale(0);
  }
}
@keyframes lds-ellipsis2 {
  0% {
    transform: translate(0, 0);
  }
  100% {
    transform: translate(24px, 0);
  }
}
</style>
