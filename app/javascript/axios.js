import axios from 'axios';

export default axios;

document.addEventListener(
  'DOMContentLoaded', () => {
    const csrfToken = document.querySelector("meta[name=csrf-token]").content
    axios.defaults.headers.common['X-CSRF-Token'] = csrfToken
  }
)
