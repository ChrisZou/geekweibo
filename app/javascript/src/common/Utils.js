import DOMPurify from 'dompurify'
import marked from 'marked'

const markdown = (text) => marked(DOMPurify.sanitize(text))

const scaledAvatar = (avatar, nickname, timestamps) => {
  if (!timestamps) timestamps = 0
  return avatar
    ? `${avatar}?x-oss-process=image/resize,m_fill,h_100,w_100&s=${timestamps}`
    : `https://ui-avatars.com/api/?background=444444&name=${nickname}&length=1&color=eeeeee`
}

export {
  markdown, scaledAvatar
}
