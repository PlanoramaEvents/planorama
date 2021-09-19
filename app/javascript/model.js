import defaults         from 'lodash/defaults'
import defaultsDeep     from 'lodash/defaultsDeep'
import defaultTo        from 'lodash/defaultTo'

import {http as axios} from './http'
import Vue from 'vue';
import {Model, Collection} from 'vue-mc'
import {jwtToken} from './utils/jwt_utils';

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
export class PlanoModel extends Model {
  schema() {
    function makeschema(fields) {
      return Object.keys(fields).reduce((prev, curr) => {
        const val = fields[curr]
        let type = "text"
        if (val instanceof Object) {
          // todo figure out how to nest objects??
        }
        else if (val === true || val === false) {
          type = "checkbox"
        }
        return Object.assign(prev,{[curr]: {
          label: curr.split('_').map(w => w.substr(0,1).toUpperCase() + w.substr(1)).join(' '),
          type
        }})
      }, {})
    }
    const defaults = this.defaults();
    return makeschema(defaults);
  }

  options() {
    return {
      methods: {
        "fetch":  "GET",
        "save":   "POST",
        "update": "PUT",
        "create": "POST",
        "patch":  "PATCH",
        "delete": "DELETE",
      }
    }
  }

  onSaveFailure(error) {
    alert("Something went horribly wrong. Please reload your page. " + error)
  }

  // We need to put the CSRF token in the header
  getDefaultHeaders() {
    return {
      'Authorization': jwtToken()
    }
  }
}

export class PlanoCollection extends Collection {
  defaults() {
    return {
      perPage: 10,
      page: 1,
      currentPage: 1,
      total: 0,
      sortField: 'updated_at',
      sortOrder: 'asc',
      filter: ''
    }
  }

  getModelsFromResponse(response) {
    let models = super.getModelsFromResponse(response);
    return models.data ? models.data : models;
  }

  onFetchSuccess(response) {
    if(response.response.data && response.response.data.meta){
      console.log(response.response.data.meta)
      Vue.set(this, 'total', response.response.data.meta.total);
      Vue.set(this, 'perPage', response.response.data.meta.perPage);
      // TODO figure out how not to go back to the server every time
      this.clearModels();
    }
    return super.onFetchSuccess(response);
  }

}
