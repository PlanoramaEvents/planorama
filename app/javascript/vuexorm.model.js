import { Model } from '@vuex-orm/core';
import { v4 as uuid } from 'uuid';

export const SELECT = "SELECT";
export const UNSELECT = "UNSELECT";

export class PlanoModel extends Model {

  static fetch() {
    this.api().get(this.apiEndpoint, {
      dataTransformer: (response) => {
        return response.data.data
      }
    })
  }

  /*
  ctx:
    currentPage: number
    perPage: number
    filter: value of filter prop 
      note: where can take a filter function
    sortBy: string
    sortDesc: boolean
    apiUrl: value of api-url prop
  */
  static provider (ctx) {
    return this.query()
      .where(ctx.filter)
      .orderBy(ctx.sortBy, ctx.sortDesc ? 'desc': 'asc')
      .limit(perPage)
      .offset(currentPage * perPage)
      .get()
  }
}

export const planoModelStore = {
  state: {
    selectedId: null
  },

  getters: {
    selected: (state, getters) => {
      return getters.find(state.selectedId)
    }
  },
 
  mutations: {
    [SELECT] (state, id) {
      state.selectedId = id;
    },
    [UNSELECT] (state) {
      state.selectedId = null;
    }
  }
}
