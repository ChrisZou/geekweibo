<template>
<p>{{ message }}</p>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue.app!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
