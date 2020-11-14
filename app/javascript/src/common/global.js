const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
window.get = (url) => {
  return fetch(url, {
    method: 'GET',
    headers: {'content-type': 'application/json'},
  })
    .then(response => response.json())
}

window.post = (url, data) => {
  return fetch(url, {
    method: 'POST',
    headers: {'content-type': 'application/json', "accept": "application/json", 'X-CSRF-Token': csrfToken},
    body: JSON.stringify(data),
  })
    .then(res => res.json())
}

window.delete = (url, data) => {
  return fetch(url, {
    method: 'DELETE',
    headers: {'content-type': 'application/json', "accept": "application/json", 'X-CSRF-Token': csrfToken},
    body: JSON.stringify(data),
  })
}

window.user_signed_in = () => {
  return sessionStorage.getItem('loggedIn')
}

window.currentUser = () => {
  if (window._currentUser) {
    return window._currentUser
  }
  const currentUserStr = sessionStorage.getItem("current_user")
  if (currentUserStr) {
    window._currentUser = JSON.parse(currentUserStr)
  }
  return window._currentUser
}
