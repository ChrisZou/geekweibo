<template>
  <div>
    <div>
      <div class="flex flex-col items-end mt-4">
        <div class="w-full rounded-md shadow-sm">
          <textarea
            v-model="new_tweet"
            rows="3"
            class="block w-full mt-1 form-textarea transition duration-150 ease-in-out sm:text-sm sm:leading-5"
            v-on:keydown.meta.enter="addTweet()"
            v-on:keyup="saveTweetLocally"
            placeholder="学到什么了呢？跟大家分享一下"
          ></textarea>
        </div>
        <button
          class="px-4 py-2 mt-2 text-sm font-medium text-white bg-indigo-600 border border-transparent rounded-md shadow-sm hover:bg-indigo-500 focus:outline-none focus:shadow-outline-blue focus:bg-indigo-500 active:bg-indigo-600 transition duration-150 ease-in-out"
          @click.stop="addTweet"
        >发布</button>
      </div>
    </div>

    <h1 class="mt-4 mb-8 text-4xl">最新动态</h1>
    <div id="app" class="mt-8">
      <TweetList v-bind:tweets_url="tweets_url"></TweetList>
    </div>
  </div>
</template>

<script>
import TweetList from "./list.vue";
import LoginDialog from "../common/LoginDialog.vue";
import Vue from "vue/dist/vue.esm";
import VModal from "vue-js-modal";
Vue.use(VModal, { dialog: true });

export default {
  components: { TweetList, LoginDialog },
  props: ["tweets", "tweets_url"],
  mounted() {
    autosize(document.querySelector("textarea"));
  },
  data() {
    return {
      new_tweet: "",
      loadMore: true
    };
  },
  methods: {
    loadMoreTweet() {
      console.log("loading more");
    },
    addTweet() {
      if (sessionStorage.getItem("loggedIn")) {
        if (this.new_tweet.trim() === "") return;

        post("/tweets", { tweet: { body: this.new_tweet } }).then(data => {
          localStorage.setItem("new_tweet_backup", "");
          location.reload();
        });
      } else {
        this.$modal.show(LoginDialog, {}, { height: "auto", width: 400 });
      }
    },
    saveTweetLocally() {
      localStorage.setItem("new_tweet_backup", this.new_tweet);
    }
  }
};
</script>
