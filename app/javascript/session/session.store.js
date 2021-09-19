import { BasePlanoStore } from "../model.store";
import { SessionService } from "./session.service";

export const SET_SESSION_USER = "SET SESSION USER";
export const GET_SESSION_USER = "GET SESSION USER";

export class SessionStore extends BasePlanoStore {
  constructor(moduleName, namespaced) {
    super(moduleName, namespaced);
    const sessionService = new SessionService();

    // How is this set ???
    this.state = {
      user: {}
    }
    this.mutations = {
      [SET_SESSION_USER] (state, user) {
        state.user = user
      }
    }
    this.actions = {
      [GET_SESSION_USER] ({commit, state}) {
        // only fetch session if we don't have one
        // TODO is that right
        if(!state.user.id) {
          sessionService.getSessionUser().subscribe((user) => {
            commit(SET_SESSION_USER, user)
          })
        }
      }
    }
  }
}

export const store = new SessionStore('session', true)
