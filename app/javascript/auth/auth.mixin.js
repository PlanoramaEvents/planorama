import {http as axios} from '@/http';

export const authMixin = {
  methods: {
    signOut() {
      const body = new FormData();
      body.append("_method", "delete")
      // const headers = {'Authorization': jwtToken()}
      return axios.post('/auth/sign_out', body);
    }
  }
}

export default authMixin;
