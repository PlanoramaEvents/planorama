import { SELECTED } from './model.store';

export const personModel = 'person';

export const personEndpoints = {
  [personModel]: 'person'
}

export const personStore = {
  selected: {
    [personModel]: undefined
  },
  getters: {
    selectedPerson(state, getters) {
      return getters[SELECTED](personModel);
    },
  },
}
