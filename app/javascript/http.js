import Axios from 'axios-observable';
import {jwtToken} from './utils/jwt_utils';

// here
export const http = axios.create({})

http.interceptors.request.use(
    config => {
      config.headers['Authorization'] = jwtToken()
      return config;
    },
    error => Promise.reject(error)
  );
