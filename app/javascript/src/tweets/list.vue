<template>
  <div>
    <div
      class="flex flex-row mb-4 bg-white shadow sm:rounded-lg"
      v-for="tweet in items"
      :key="tweet.id"
    >
      <img :src="tweet.user.avatar" class="inline-block w-12 h-12 mt-4 ml-4 rounded-full" />
      <div class="w-full p-4">
        <h3 class="text-lg font-medium text-gray-900 leading-6">{{ tweet.user.nickname }}</h3>
        <div class="mt-1 text-sm text-gray-500 leading-5 markdown">{{ tweet.body }}</div>
        <div class="flex items-center justify-end mt-4">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="w-4 h-4 fill-current"
            :class="tweet.liked ? 'text-red-500' : 'text-black'"
            viewBox="0 0 24 24"
            @click.stop="toggleLike(tweet)"
          >
            <path
              class="heroicon-ui"
              d="M12.76 3.76a6 6 0 018.48 8.48l-8.53 8.54a1 1 0 01-1.42 0l-8.53-8.54a6 6 0 018.48-8.48l.76.75.76-.75zm7.07 7.07a4 4 0 10-5.66-5.66l-1.46 1.47a1 1 0 01-1.42 0L9.83 5.17a4 4 0 10-5.66 5.66L12 18.66l7.83-7.83z"
            />
          </svg>
          <span class="inline-block ml-1 text-xs">{{ tweet.like_count }}</span>
        </div>
      </div>
    </div>

    <div
      v-show="show_login"
      class="fixed inset-x-0 bottom-0 px-4 pb-6 sm:inset-0 sm:p-0 sm:flex sm:items-center sm:justify-center"
    >
      <!--
    Background overlay, show/hide based on modal state.

    Entering: "ease-out duration-300"
      From: "opacity-0"
      To: "opacity-100"
    Leaving: "ease-in duration-200"
      From: "opacity-100"
      To: "opacity-0"
      -->
      <div class="fixed inset-0 transition-opacity">
        <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
      </div>

      <!--
    Modal panel, show/hide based on modal state.

    Entering: "ease-out duration-300"
      From: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
      To: "opacity-100 translate-y-0 sm:scale-100"
    Leaving: "ease-in duration-200"
      From: "opacity-100 translate-y-0 sm:scale-100"
      To: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
      -->
      <div
        v-click-outside="hideLoginDialog"
        class="px-4 pt-5 pb-4 overflow-hidden bg-white rounded-lg shadow-xl transform transition-all sm:max-w-sm sm:w-full sm:p-6"
        role="dialog"
        aria-modal="true"
        aria-labelledby="modal-headline"
      >
        <div>
          <div class="flex items-center justify-center w-12 h-12 mx-auto rounded-full">
            <svg
              role="img"
              viewBox="0 0 24 24"
              class="w-12 h-12"
              xmlns="http://www.w3.org/2000/svg"
            >
              <title>GitHub icon</title>
              <path
                d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"
              />
            </svg>
          </div>
        </div>
        <div class="mt-5 sm:mt-6">
          <span class="flex w-full rounded-md shadow-sm">
            <a
              type="button"
              href="<%= user_github_omniauth_authorize_path %>"
              class="inline-flex justify-center w-full px-4 py-2 text-base font-medium text-white bg-indigo-600 border border-transparent rounded-md leading-6 shadow-sm hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo transition ease-in-out duration-150 sm:text-sm sm:leading-5"
            >Login with Github</a>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
/* import { mixin as clickaway } from "vue-clickaway"; */
import ClickOutside from "vue-click-outside";

export default {
  // do not forget this section
  directives: {
    ClickOutside
  },
  props: ["tweets"],
  data: function() {
    return {
      show_login: false,
      items: this.tweets
    };
  },
  computed: {},
  methods: {
    toggleLike(tweet) {
      console.log(`toggling like state of ${tweet.id}`);
      if (!sessionStorage.getItem("loggedIn")) {
        this.show_login = true;
        return;
      }

      post("/likes", {
        likable_id: tweet.id,
        likable_type: "Tweet",
        liked: !tweet.liked
      }).then(res => res.json());

      this.items = this.items.map(t => {
        if (t.id == tweet.id) t.liked = !t.liked;
        return t;
      });
    },

    hideLoginDialog() {
      console.log();
      this.show_login = false;
    }
  },
  mounted() {
    // prevent click outside event with popupItem.
    /* this.popupItem = this.$el; */
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
