const md = require('markdown-it')({
  html:         false,        // Enable HTML tags in source
  breaks:       true,        // Convert '\n' in paragraphs into <br>
  // langPrefix:   'language-',  // CSS language prefix for fenced blocks. Can be useful for external highlighters.
  linkify:      true,        // Autoconvert URL-like text to links
}).disable(['image', 'hr', 'table', 'list', 'heading', 'lheading', 'blockquote', 'reference', 'html_block', 'html_inline'])

const markdown = (text) => md.render(text)

const scaledAvatar = (avatar, nickname, timestamps) => {
  if (!timestamps) timestamps = 0
  if (avatar) {
    if (timestamps) {
      return `${avatar}?x-oss-process=image/resize,m_fill,h_100,w_100&s=${timestamps}`
    } else {
      return `${avatar}?x-oss-process=image/resize,m_fill,h_100,w_100`
    }
  } else {
    return `https://ui-avatars.com/api/?background=444444&name=${nickname}&length=1&color=eeeeee`
  }
}

export {
  markdown, scaledAvatar
}
