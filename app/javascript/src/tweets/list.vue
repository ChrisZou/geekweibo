<template>
  <div>
    <div
      class="flex flex-row mb-4 bg-white shadow sm:rounded-lg"
      v-for="tweet in items"
      :key="tweet.id"
    >
      <img
        :src="tweet.user.avatar"
        class="inline-block w-12 h-12 mt-4 ml-4 rounded-full"
      />
      <div class="w-full p-4">
        <h3 class="text-lg font-medium text-gray-900 leading-6">
          {{ tweet.user.nickname }}
        </h3>
        <div
          class="mt-1 text-sm text-gray-500 leading-5 markdown"
          v-html="markdown(tweet.body)"
        ></div>
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
  </div>
</template>

<script>
const marked = require("marked");
marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  breaks: true,
  pedantic: false,
  smartLists: true,
  smartypants: false
});

export default {
  props: ["tweets", "dialogShower"],
  data: function() {
    return {
      items: this.tweets
    };
  },
  methods: {
    toggleLike(tweet) {
      console.log(`toggling like state of ${tweet.id}`);
      if (!sessionStorage.getItem("loggedIn")) {
        this.dialogShower();
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
    markdown(body) {
      return marked(body);
    }
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
