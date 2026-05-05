//import Axios from 'axios-observable';
import axios from 'axios';

// here
export const http = axios.create({})

http.interceptors.response.use(
  response => {
    if (response.status == 503 || response.status == 307) {
      window.location = "/maintenance.html"
    }
    return response;
  },
  error => {
    // console.debug("AXIOS error", error)
    // console.debug("AXIOS error.response",error.response)
    // if (error.response && (error.response.status == 503 || response.status == 307)) {
    //   window.location = "/maintenance.html"
    // }

    return Promise.reject(error)
  }
);
