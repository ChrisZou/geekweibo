window.get = (url) => {
  return fetch(url, {
    method: 'GET', // *GET, POST, PUT, DELETE, etc.
    headers: { 'content-type': 'application/json' },
  })
  .then(response => response.json()) // parses response to JSON
}

window.post = (url, data) => {
  return fetch(url, {
    method: 'POST', // *GET, POST, PUT, DELETE, etc.
    headers: { 'content-type': 'application/json', "accept": "application/json" },
    body: JSON.stringify(data), // must match 'Content-Type' header
  })
  .then(response => response.json()) // parses response to JSON
}
