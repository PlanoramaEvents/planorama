import Axios from 'axios-observable';
//import { csrfToken } from '@rails/ujs';

export const http = Axios.create({ })

// TODO
http.interceptors.request.use(
    config => {
      // if (!config.headers['X-CSRF-TOKEN']) {
      //   config.headers['X-CSRF-TOKEN'] = csrfToken()
      // }
      // TODO: change 
      config,headers['Authorization'] = jwtToken()
      return config;
    },
    error => Promise.reject(error)
  );
