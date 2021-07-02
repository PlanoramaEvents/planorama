import PlanoModel from '../model.js';
import {Collection} from 'vue-mc';

export class Setting extends PlanoModel {
  defaults() {
    return {
      id: null,
      name: null,
      value: null
    }
  }

  onSave() {
    return Promise.reject('no save for yooooooo');
  }
}

export class Settings extends Collection {
  options() {
    return {
      model: Setting
    }
  }
}

export const settings_columns = [
  {
    key: '$.id',
    label: 'ID',
  },
  {
    key: '$.name',
    label: 'Name',
    sortable: true
  },
  {
    key: '$.value',
    label: 'Value'
  }
]
