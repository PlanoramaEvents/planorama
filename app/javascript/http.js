import axios from 'axios';

// here
export const http = axios.create({})

// TODO
http.interceptors.request.use(
    config => {
      // TODO: change, how do we set the JWT token?
      config,headers['Authorization'] = jwtToken()
      return config;
    },
    error => Promise.reject(error)
  );
