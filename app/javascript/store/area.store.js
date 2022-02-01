import { NEW } from './model.store';

export const NEW_AREA = 'NEW AREA';

export const areaModel = 'area';

export const areaEndpoints = {
  [areaModel]: 'area'
}

export const areaStore = {
  actions: {
    [NEW_AREA] ({dispatch}, attributes) {
      return dispatch(NEW, {model: areaModel, selected: false, ...attributes})
    },
  },
  selected: {
    [areaModel]: undefined
  },
  getters: {
  },
}
