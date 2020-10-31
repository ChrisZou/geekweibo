<template>
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
      <div stroke="currentColor" class="p-4 pb-0 text-sm text-gray-500 leading-5 markdown sharing-image" v-html="markdown(sharing_tweet.body)"></div>
      <qrcode :value="`https://geekweibo.com/tweets/${sharing_tweet.id}`" class="self-center mb-0" :options="{ width: 150 }"></qrcode>
      <span class="self-center mb-4 text-gray-600">geekweibo.com</span>
    </div>
    <svg class="w-8 h-8 mb-4 cursor-pointer" @click="downloadSharingImage" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
    </svg>
  </div>
</template>

<script>
import { markdown, scaledAvatar } from '../common/Utils.js'
import html2canvas from 'html2canvas'

export default {
  props: ['sharing_tweet'],
  data() {
    return {}
  },
  methods: {
    scaledAvatar: scaledAvatar,
    markdown: markdown,
    downloadSharingImage() {
      html2canvas(document.querySelector('#sharing-image-root'), { useCORS: true, imageTimeout: 2000 }).then(canvas => {
        const img = document.createElement('a')
        img.href = canvas.toDataURL('image/jpeg').replace('image/jpeg', 'image/octet-stream')
        img.download = `${this.sharing_tweet.id}.jpg`
        img.click()
      })
    },
  },
}
</script>

<style lang="scss" scoped>
</style>>
