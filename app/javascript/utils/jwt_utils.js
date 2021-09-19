//

export function setJWTToken(token) {
  // console.debug('SET JWT token', token);
  localStorage.setItem('gr_jwt_token', token);
}

export function jwtToken() {
  let tok = localStorage.getItem('gr_jwt_token');
  // console.debug('GET JWT token', tok);

  return tok;
}
