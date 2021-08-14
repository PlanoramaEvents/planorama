import { http } from '../http';
import { map, catchError } from 'rxjs';

export class SessionService {
  getSessionUser() {
    return http.get('/people/me').pipe(
      catchError((a,b,c) => console.log(a,b,c)),
      map(r => r.data)
    );
  }
}
