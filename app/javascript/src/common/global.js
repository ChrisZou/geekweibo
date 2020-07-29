window.get = (url) => {
  return fetch(url, {
    method: 'GET', 
    headers: { 'content-type': 'application/json' },
  })
  .then(response => response.json()) 
}

window.post = (url, data) => {
  return fetch(url, {
    method: 'POST',
    headers: { 'content-type': 'application/json', "accept": "application/json" },
    body: JSON.stringify(data),
  })
  .then(res => res.json())
}

window.delete = (url, data) => {
  return fetch(url, {
    method: 'DELETE',
    headers: { 'content-type': 'application/json', "accept": "application/json" },
    body: JSON.stringify(data),
  })
  .then(res => res.json())
}
