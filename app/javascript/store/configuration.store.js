import { NEW } from './model.store';

export const configurationModel = 'configuration';

export const NEW_CONFIGURATION = 'NEW CONFIGURATION';

export const configurationEndpoints = {
  [configurationModel]: 'configuration'
}

export const configurationStore = {
  actions: {
    [NEW_CONFIGURATION] ({dispatch}, {configuration}) {
      return dispatch(NEW, {model: configurationModel, selected: false, ...configuration});
    },
  },
  selected: {
    [configurationModel]: undefined
  },
  getters: {
  }
}
