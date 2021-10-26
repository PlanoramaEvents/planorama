import { SELECTED, NEW } from './model.store';

export const NEW_PERSON = 'NEW PERSON';
export const personModel = 'person';

export const personEndpoints = {
  [personModel]: 'person'
}

export const personStore = {
  actions: {
    [NEW_PERSON] ({dispatch}, newPerson) {
      // console.debug('SAVING PERSON', newPerson);
      return dispatch(NEW, {model: personModel, selected: false, item: newPerson})
    },
  },
  selected: {
    [personModel]: undefined
  },
  getters: {
    selectedPerson(state, getters) {
      return getters[SELECTED](personModel);
    },
  },
}
