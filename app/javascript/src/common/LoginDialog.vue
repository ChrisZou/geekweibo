<template>
  <div class="flex flex-col items-center pb-6">
    <div class="px-4 sm:p-0 sm:flex sm:items-center sm:justify-center">
      <div
        class="px-4 pt-5 pb-4 overflow-hidden bg-white rounded-lg transform transition-all sm:max-w-sm sm:w-full sm:p-6"
        role="dialog"
        aria-modal="true"
        aria-labelledby="modal-headline"
      >
        <div>
          <div class="flex items-center justify-center w-12 h-12 mx-auto rounded-full">
            <svg role="img" viewBox="0 0 24 24" class="w-12 h-12">
              <title>GitHub icon</title>
              <path
                d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"
              />
            </svg>
          </div>
        </div>
        <div class="mt-5 sm:mt-6">
          <span class="flex w-full rounded-md shadow-sm">
            <form data-turbo="false" class="w-48" method="post" action="/users/auth/github">
              <input
                class="inline-flex justify-center w-full px-4 py-2 text-base font-medium text-white bg-indigo-600 border border-transparent rounded-md leading-6 shadow-sm hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo transition ease-in-out duration-150 sm:text-sm sm:leading-5"
                type="submit"
                value="Github 登录"
                data-disable-with="登录中..."
              /><input type="hidden" name="authenticity_token" v-model="csrfToken" />
            </form>
          </span>
        </div>
      </div>
    </div>
    <a href="/welcome/agreement" class="text-xs text-gray-500">登录意味着你同意用户协议和隐私政策</a>
  </div>
</template>
<script>
export default {
  data() {
    return { csrfToken: '' }
  },
  created() {
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  },
  methods: {},
}
</script>
