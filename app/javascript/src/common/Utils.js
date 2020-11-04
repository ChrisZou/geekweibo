import DOMPurify from 'dompurify'
import marked from 'marked'
marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  breaks: true,
  pedantic: false,
  smartLists: true,
  smartypants: false,
})

const markdown = (text) => marked(DOMPurify.sanitize(text))

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
