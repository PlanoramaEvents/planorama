import {PlanoModel} from '../model.js';
import { http}  from '../http';

export class Configuration extends PlanoModel {
  defaults() {
    return {
      id: null,
      parameter: null,
      parameter_value: null,
      updated_at: new Date(),
      created_at: new Date()
    }
  }

  routes() {
    return {
      fetch: '/configurations/{id}',
      create: '/configurations',
      save: '/configurations/{id}',
      update: '/configurations/{id}',
      delete: '/configurations/{id}',
    }
  }
}

export class Configurations {

  constructor() {
    // this needs all the properties you want to be reactive.
    this.event_email = {parameter: 'event_email', parameter_value: null};
    this.event_phone = {parameter: 'event_phone', parameter_value: null};
    this.data = {};
    this.config_names = [];
  }

  configs(predicate) {
    let configs = this.config_names.filter(predicate || (() => true)).map(k => this[k])
    console.log(configs)
    return configs
  }

  fetch() {
    return new Promise((res, rej) => {
      http.get('/configurations').then(resp => {
        for (let key in resp.data) {
          let val = resp.data[key]
          this[key] = val ? new Configuration(val) : new Configuration({parameter: key});
        }
        this.data = resp.data;
        this.config_names = Object.keys(resp.data);
        res(this)
      })
    })
  }

  save(predicate) {
    return Promise.all(this.configs(predicate).map(c => c.changed() ? c.save() : null).filter(x => x))
  }

  reset(predicate) {
    this.configs(predicate).map(c => c.reset())
  }

  changed(predicate) {
    return this.configs(predicate).some(c => c.changed())
  }
}

export const configurations_columns = [
  {
    key: '$.id',
    label: 'ID',
  },
  {
    key: '$.parameter',
    label: 'Name',
    sortable: true
  },
  {
    key: '$.parameter_value',
    label: 'Value'
  }
]
