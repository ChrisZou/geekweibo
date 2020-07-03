<template>
  <div>
    <div
      class="flex flex-row mb-4 bg-white shadow sm:rounded-lg"
      v-for="tweet in tweets"
      :key="tweet.id"
    >
      <img :src="tweet.user.avatar" class="inline-block w-12 h-12 mt-4 ml-4 rounded-full" />
      <div class="w-full px-4 py-5 sm:p-5">
        <h3 class="text-lg font-medium text-gray-900 leading-6">{{tweet.user.nickname}}</h3>
        <div class="mt-2 text-sm text-gray-500 leading-5 markdown">{{ tweet.body }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["tweets"],
  data: function() {
    return {
      message: "Hello Vue on Rails!"
    };
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
