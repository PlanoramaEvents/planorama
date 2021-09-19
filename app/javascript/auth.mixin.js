// import { csrfToken, csrfParam } from '@rails/ujs';
import axios from 'axios';
import {jwtToken} from './utils/jwt_utils';

const authMixin = {
  methods: {
    signOut() {
      const body = new FormData();
      body.append("_method", "delete")
      const headers = {'Authorization': jwtToken()}
      return axios.post('/auth/sign_out', body, {headers});
    }
  }
}

export default authMixin;

// https://www.npmjs.com/package/axios-jwt
// https://medium.com/ruby-daily/a-devise-jwt-tutorial-for-authenticating-users-in-ruby-on-rails-ca214898318e
// https://github.com/waiting-for-dev/devise-jwt
