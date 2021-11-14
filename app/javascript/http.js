//import Axios from 'axios-observable';
import axios from 'axios';
// import {jwtToken, setJWTToken} from './utils/jwt_utils';

// here
export const http = axios.create({})

// http.interceptors.request.use(
//   request => {
//     let token = jwtToken()
//     if (token) {
//       request.headers['Authorization'] = token
//     }
//     return request;
//   },
//   error => Promise.reject(error)
// );
//
// http.interceptors.response.use(
//   response => {
//     // TODO: should intercept the not auth here ???
//     let token = response.headers['authorization']
//     if (token) {
//       setJWTToken(token)
//     }
//     return response;
//   },
//   error => Promise.reject(error)
// );
