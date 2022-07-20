//import Axios from 'axios-observable';
import axios from 'axios';

// here
export const http = axios.create({})

http.interceptors.response.use(
  response => {
    if (response.status == 503) {
      window.location = "/maintenance.html"
    }
    return response;
  },
  error => {
    if (error.response.status == 503) {
      window.location = "/maintenance.html"
    }

    return Promise.reject(error)
  }
);
