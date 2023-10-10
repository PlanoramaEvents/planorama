import { NEW } from './model.store';

export const NEW_PAGE_CONTENT = 'NEW PAGE CONTENT';

export const pageContentModel = 'page_content';

export const pageContentEndpoints = {
  [pageContentModel]: 'page_content'
}

export const pageContentStore = {
  actions: {
    [NEW_PAGE_CONTENT] ({dispatch}, attributes) {
      return dispatch(NEW, { model: pageContentModel, selected: false, ...attributes})
    },
  },
  selected: {
    [pageContentModel]: undefined
  },
  getters: {
  }
}
