import defaults         from 'lodash/defaults'
import defaultsDeep     from 'lodash/defaultsDeep'
import defaultTo        from 'lodash/defaultTo'

import axios from 'axios'
import {Model} from 'vue-mc'

// TODO: modify for routes etc
// make sure that save sans id in URL and update has id
/*
routes() {
  // TODO: do we need a custom route for update instaed of save???
  // see http://vuemc.io/#model-request-custom
  return {
    fetch: '/people/{id}',
    save:  '/people/{id}',
  }
}
*/
export default class PlanoModel extends Model {
  options() {
    return {
      patch: true
    }
  }


  save(options = {}) {
    const csrfToken = document.querySelector("meta[name=csrf-token]").content
    let headers = this.getSaveHeaders();
    headers['X-CSRF-Token'] = csrfToken;
    let config = () => {
      return {
        url     : defaultTo(options.url,     this.getSaveURL()),
        method  : defaultTo(options.method,  this.getSaveMethod()),
        data    : defaultTo(options.data,    this.getSaveData()),
        params  : defaults (options.params,  this.getSaveQuery()),
        headers : defaults (options.headers, headers),
      };
    };

    let save_promise = this.request(
      config,
      this.onSave,
      this.onSaveSuccess,
      this.onSaveFailure
    );

    save_promise.catch(
      (error) => {
        console.error("We have an error", error.response.response.data.error)
        // Notification.open({
        //   message: error.response.response.data.error,
        //   type: 'is-danger',
        //   hasIcon: true,
        //   closable: true,
        //   indefinite: true
        // })
      }
    );

    return save_promise;
  }
}

document.addEventListener(
  'DOMContentLoaded', () => {
    const csrfToken = document.querySelector("meta[name=csrf-token]").content
    axios.defaults.headers.common['X-CSRF-Token'] = csrfToken
  }
)
