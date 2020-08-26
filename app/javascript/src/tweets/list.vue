<template>
  <div>
    <div
      class="flex flex-row mb-4 bg-white shadow sm:rounded-lg"
      v-for="(tweet, index) in items"
      :key="tweet.id"
    >
      <img
        :src="tweet.user.avatar"
        class="inline-block object-cover w-12 h-12 mt-4 ml-4 rounded-full"
      />
      <div class="relative w-full p-4">
        <h3 class="text-lg font-medium text-gray-900 leading-6">
          {{ tweet.user.nickname }}
        </h3>
        <div
          stroke="currentColor"
          class="mt-1 text-sm text-gray-500 leading-5 markdown"
          v-html="markdown(tweet.body)"
        ></div>
        <div class="absolute top-1 right-1">
          <v-popover>
            <svg
              v-if="isAuthor(tweet)"
              class="w-6 h-6 p-1 rounded-full hover:bg-gray-200 right-2 top-2"
              viewBox="0 0 20 20"
            >
              <path
                d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
              />
            </svg>
            <template slot="popover">
              <div
                class="flex items-center py-1 bg-white border border-gray-100 border-solid rounded-sm focus:outline-none"
              >
                <span
                  class="px-8 py-2 text-sm tracking-wider cursor-pointer hover:bg-gray-200"
                  @click="confirmDeleteTweet(tweet)"
                  >删除</span
                >
              </div>
            </template>
          </v-popover>
        </div>
        <div class="flex items-center justify-end mt-4">
          <svg
            fill="none"
            class="w-4 h-4"
            stroke-width="2"
            viewBox="0 0 24 24"
            stroke="currentColor"
            @click.stop="showTweetComment(tweet)"
          >
            <path
              d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
            />
          </svg>
          <span class="inline-block ml-1 text-xs" v-if="tweet.comment_count">{{
            tweet.comment_count
          }}</span>
          <svg
            viewBox="0 0 24 24"
            class="w-4 h-4 ml-4 fill-current"
            :class="tweet.liked ? 'text-red-500' : 'text-black'"
            @click.stop="toggleLike(tweet)"
          >
            <path
              class="heroicon-ui"
              d="M12.76 3.76a6 6 0 018.48 8.48l-8.53 8.54a1 1 0 01-1.42 0l-8.53-8.54a6 6 0 018.48-8.48l.76.75.76-.75zm7.07 7.07a4 4 0 10-5.66-5.66l-1.46 1.47a1 1 0 01-1.42 0L9.83 5.17a4 4 0 10-5.66 5.66L12 18.66l7.83-7.83z"
            />
          </svg>
          <span v-if="tweet.like_count" class="inline-block ml-1 text-xs">
            {{ tweet.like_count }}
          </span>
        </div>
        <div v-if="tweet.show_comment" class="mt-2 rounded">
          <div class="flex flex-col p-2 bg-gray-100 rounded">
            <div class="flex flex-row">
              <img
                v-if="currentUser"
                :src="currentUser.avatar"
                class="object-cover w-8 h-8 rounded-full"
              />
              <div
                contenteditable="true"
                v-bind:ref="'tweet_comment_inbox_' + index"
                v-html="tweet.new_comment"
                @input="e => updateNewCommentOf(e, tweet)"
                class="w-full p-2 ml-2 bg-white border-indigo-100 border-solid rounded outline-none"
              ></div>
            </div>
            <button
              @click="e => postComment(e, tweet, index)"
              class="self-end px-3 py-2 mt-2 text-xs text-white bg-indigo-500 rounded outline-none focus:outline-none active:bg-indigo-600"
            >
              评论
            </button>
          </div>
          <div
            v-for="comment in tweet.comments"
            class="flex flex-row mt-3"
            v-bind:key="comment.id"
          >
            <img
              :src="comment.user.avatar"
              class="object-cover w-8 h-8 rounded-full"
            />
            <div class="w-full ml-2">
              <div class="flex items-center justify-between">
                <div class="text-xs font-medium text-gray-900">
                  {{ comment.user.nickname }}
                </div>
                <svg
                  class="w-5 h-5 p-1 text-gray-400 rounded-full hover:bg-gray-200"
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
                class="text-sm text-gray-500 markdown"
                v-html="markdown(comment.body)"
              ></div>
            </div>
          </div>
          <div
            v-if="tweet.has_more_comment"
            class="pt-3 mt-3 text-sm text-center border-t border-gray-200"
          >
            查看更多
          </div>
        </div>
      </div>
    </div>
    <v-dialog />
  </div>
</template>

<script>
import { VTooltip, VPopover, VClosePopover } from "v-tooltip";

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
  components: { "v-popover": VPopover },
  props: ["tweets", "dialogShower"],
  data() {
    this.tweets.forEach(t => {
      t.showMenu = false;
      t.comment_count = t.comments.length;
      t.has_more_comment = t.comments.length > 5;
      t.comments = t.comments.slice(0, 5);
    });
    return {
      items: this.tweets,
      currentUser: window.currentUser()
    };
  },
  methods: {
    showMenuForTweetItem(tweet) {
      tweet.showMenu = !tweet.showMenu;
    },
    toggleLike(tweet) {
      if (!sessionStorage.getItem("loggedIn")) {
        this.dialogShower();
        return;
      }

      const action = tweet.liked ? window.delete : window.post;
      action("/likes", {
        likable_id: tweet.id,
        likable_type: "Tweet"
      }).then(res => console.log("like/unlike succeed"));

      tweet.liked = !tweet.liked;
      tweet.like_count += tweet.liked ? 1 : -1;
    },
    showTweetComment(tweet) {
      if (!sessionStorage.getItem("loggedIn")) {
        this.showLoginDialog();
        return;
      }

      // show comment modal
      this.items = this.items.map(t => {
        if (t.id == tweet.id) {
          t.show_comment = true;
        }
        return t;
      });
      tweet.show_comment = true;
    },
    updateNewCommentOf(e, tweet) {
      tweet.new_comment = e.target.innerText;
    },
    postComment(e, tweet, index) {
      if (!tweet.new_comment) return;

      post("/comments", {
        tweet_id: tweet.id,
        body: tweet.new_comment
      }).then(data => {
        tweet.comments.unshift({
          user: this.currentUser,
          body: data.body
        });
        tweet.new_comment = "";
        this.$refs["tweet_comment_inbox_" + index][0].innerText = "";
      });
    },
    confirmDeleteTweet(tweet) {
      console.log("showing dialog");

      this.$modal.show("dialog", {
        title: "确定删除这条推文？",
        text: "推文一旦删除，将无法恢复",
        buttons: [
          {
            title: "取消",
            class: "focus:outline-none py-3 hover:bg-gray-100 ",
            handler: () => {
              this.$modal.hide("dialog");
            }
          },
          {
            title: "确定",
            default: true,
            class: "focus:outline-none py-3 hover:bg-gray-100",
            handler: () => {
              this.$modal.hide("dialog");
              window.delete(`/tweets/${tweet.id}`).then(res => {
                this.items = this.items.filter(t => t.id != tweet.id);
              });
            }
          }
        ]
      });
    },
    confirmDeleteComment(tweet, comment) {
      this.$modal.show("dialog", {
        title: "确定删除这条评论？",
        text: "此操作无法撤销",
        buttons: [
          {
            title: "取消",
            class: "focus:outline-none py-3 hover:bg-gray-100 ",
            handler: () => {
              this.$modal.hide("dialog");
            }
          },
          {
            title: "确定",
            default: true,
            class: "focus:outline-none py-3 hover:bg-gray-100",
            handler: () => {
              this.$modal.hide("dialog");
              window.delete(`/comments/${comment.id}`).then(res => {
                tweet.comments = tweet.comments.filter(c => c.id != comment.id);
              });
            }
          }
        ]
      });
    },
    isAuthor(tweet) {
      return this.currentUser && this.currentUser.id == tweet.user.id;
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

.angle {
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 0 10px 10px 10px;
  border-color: transparent transparent #f4f5f7 transparent;
}
</style>
