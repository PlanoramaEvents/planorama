import defaults         from 'lodash/defaults'
import defaultsDeep     from 'lodash/defaultsDeep'
import defaultTo        from 'lodash/defaultTo'

import {http as axios} from './http'
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
  schema() {
    const defaults = this.defaults();
    return Object.keys(defaults).reduce((prev, curr) => {
      const val = defaults[curr]
      let type = "text"
      if (val === true || val === false) {
        type = "checkbox"
      }
      return Object.assign(prev,{[curr]: {
        label: curr.split('_').map(w => w.substr(0,1).toUpperCase() + w.substr(1)).join(' '),
        type
      }})
    }, {})
  }

  options() {
    return {
      patch: true
    }
  }

  save(options = {}) {
    let headers = this.getSaveHeaders();
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

  // We need to put the CSRF token in the header
  getDefaultHeaders() {
    const csrfToken = document.querySelector("meta[name=csrf-token]").content
    return {
      'X-CSRF-Token': csrfToken
    }
  }
}
