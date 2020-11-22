<template>
  <div class="p-4 py-6">
    <h3>给这条微博设置一个测试问题</h3>
    <input ref="input" v-model="question" autofocus="true" class="w-full mt-4 text-field" />
    <button @click="setQuestion" class="w-full mt-4 button">确定</button>
  </div>
</template>

<script>
export default {
  props: ['tweet', 'onComplete'],
  data() {
    return {
      question: '',
    }
  },
  methods: {
    async setQuestion() {
      const result = await put(`/tweets/${this.tweet.id}`, { question: this.question })
      this.onComplete()
    },
  },
}
</script>
