<template>
  <div>
    <div>
      <div class="flex flex-col items-end mt-4">
        <div class="flex flex-col w-full">
          <textarea
            v-model="new_tweet"
            rows="3"
            class="block w-full mt-1 form-textarea transition duration-150 ease-in-out sm:text-sm sm:leading-5"
            v-on:keydown.meta.enter="postTweet()"
            v-on:keyup="saveTweetLocally"
            placeholder="学到什么了呢？跟大家分享一下"
          ></textarea>
        </div>
        <span v-if="posting_error" class="text-xs text-red-500">{{ posting_error }}</span>
        <div class="flex items-start justify-between w-full mt-2">
          <div>
            <input ref="image_picker" type="file" class="hidden" @change="onFileChange" />
            <svg
              v-if="!imageUrl"
              fill="none"
              class="w-8 h-8 p-1 rounded-full cursor-pointer hover:bg-gray-200 transition duration-300 stroke-0"
              viewBox="0 0 24 24"
              @click="selectFile"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
              />
            </svg>
            <img v-if="imageUrl" @click="previewImage" class="object-cover w-28 h-28" :src="imageUrl" />
          </div>
          <button class="button" @click.stop="postTweet">发布</button>
        </div>
      </div>
    </div>

    <h1 class="mt-4 text-4xl font-medium">最新动态</h1>
    <div id="app" class="mt-8">
      <TweetList :new_tweets="new_tweets" v-bind:tweets_url="tweets_url"></TweetList>
    </div>
    <modal name="preview-image" width="800px" height="auto">
      <img :src="imageUrl" class="w-full h-full" alt="" />
    </modal>
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
  computed: {
    imageUrl() {
      return this.imageFile ? URL.createObjectURL(this.imageFile) : ''
    },
  },
  mounted() {
    autosize(document.querySelector('textarea'))
  },
  data() {
    return {
      new_tweet: localStorage.getItem('new_tweet_backup'),
      new_tweets: [],
      loadMore: true,
      currentUser: window.currentUser(),
      posting_error: '',
      imageFile: null,
    }
  },
  methods: {
    loadMoreTweet() {
      console.log('loading more')
    },
    selectFile() {
      this.$refs.image_picker.click()
    },
    onFileChange(e) {
      this.imageFile = e.target.files[0]
    },
    postTweet() {
      if (!this.currentUser) {
        this.$modal.show(LoginDialog, {}, { height: 'auto', width: 400 })
        return
      }

      if (this.new_tweet.trim() === '') return

      let formData = new FormData()
      formData.append('tweet[body]', this.new_tweet)
      if (this.imageFile) formData.append('tweet[images][]', this.imageFile)
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      fetch('/tweets', {
        method: 'POST',
        headers: { 'X-CSRF-Token': csrfToken },
        body: formData,
      })
        .then(res => res.json())
        .then(data => {
          if (data.result !== 'error') {
            this.new_tweets.unshift(data)
            localStorage.setItem('new_tweet_backup', '')
            this.new_tweet = ''
            this.posting_error = ''
            this.$refs.image_picker.value = ''
            this.imageFile = null
          } else {
            this.posting_error = data.error.body.join('; ')
          }
        })
        .catch(e => {
          console.log(e)
        })
    },
    saveTweetLocally() {
      localStorage.setItem('new_tweet_backup', this.new_tweet)
    },
    previewImage() {
      this.$modal.show('preview-image')
    },
  },
}
</script>
