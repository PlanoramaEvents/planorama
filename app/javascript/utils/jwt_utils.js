//

export function setJWTToken(token) {
  localStorage.setItem('gr_jwt_token', token);
}

export function jwtToken() {
  localStorage.getItem('gr_jwt_token');
}
