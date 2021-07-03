import PlanoModel from '../model.js';
import {Collection} from 'vue-mc';
import Vue from 'vue';

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

export class Configurations extends Collection {
  options() {
    return {
      model: Configuration
    }
  }

  routes() {
    return {
      fetch: '/configurations'
    }
  }

  getModelsFromResponse(response) {
    let models = super.getModelsFromResponse(response);
    return models.data ? models.data : models
  }

  save() {
    return Promise.all(this.models.map(m => m.save()))
  }

  makeComputed(parameter) {
    // TODO make this reactive according to vue
    Object.defineProperty(this, parameter, {
      get: function() {
        let param = this.find(c => c.parameter === parameter) 
        console.log("parameter:", param)
        return param ? param.parameter_value : null;
      },
      set: function(parameter_value) {
        let param = this.find(c => c.parameter === parameter);
        console.log("found: ", param)
        if (!param) {
          param = this.add({parameter, parameter_value})
          console.log ("attempted to make new thing", this)
        } else {
          param.parameter_value = parameter_value;
        }
      } 
    });
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
