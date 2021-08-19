// import { csrfToken, csrfParam } from '@rails/ujs';
import axios from 'axios';

const authMixin = {
  methods: {
    signOut() {
      // TODO: change 
      const body = new FormData();
      // TODO
      // body.append(csrfParam(), csrfToken())
      body.append("_method", "delete")
      const headers = {'Content-Type': 'multipart/form-data'}
      return axios.post('/auth/sign_out', body, {headers});
    }
  }
}

export default authMixin;
