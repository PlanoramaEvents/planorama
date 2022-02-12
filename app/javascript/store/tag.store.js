import { NEW } from './model.store';

// export const NEW_TAG = 'NEW TAG';

export const tagModel = 'tag';

export const tagEndpoints = {
  [tagModel]: 'tag'
}

export const tagStore = {
  actions: {
    // [NEW_TAG] ({dispatch}, attributes) {
    //   return dispatch(NEW, {model: tagModel, selected: false, ...attributes})
    // },
  },
  selected: {
    [tagModel]: undefined
  },
  getters: {
  },
}
