import axios from 'axios';
import { csrfToken } from '@rails/ujs';

export const http = axios.create({})

http.interceptors.request.use(
    config => {
      if (!config.headers['X-CSRF-TOKEN']) {
        config.headers['X-CSRF-TOKEN'] = csrfToken()
      }
      return config;
    },
    error => Promise.reject(error)
  );
