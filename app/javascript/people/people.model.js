import { Model } from '@vuex-orm/core';
import { v4 as uuid } from 'uuid';

export const SELECT = "SELECT";
export const UNSELECT = "UNSELECT";

export class Person extends Model {
  static entity = 'people'

  static fields () {
    return {
      id: this.uid(() => uuid()),
      language: this.attr(''),
      created_at: this.attr(new Date()),
      updated_at: this.attr(new Date()),
      lock_version: this.number(0),
      comments: this.attr(null),
      organization: this.attr(null),
      job_title: this.attr(null),
      pronouns: this.attr(null),
      year_of_birth: this.attr(null),
      gender: this.attr(null),
      ethnicity: this.attr(null),
      opted_in: this.boolean(false),
      // TODO figure out enums. other "tables"?
      // TODO invite_status
      // TODO acceptance_status
      registered: this.boolean(false),
      registration_type: this.attr(null), // should this be an enum?
      can_share: this.boolean(false),
      registration_number: this.attr(null),
      can_photo: this.boolean(false),
      can_record: this.boolean(false),
      name: this.attr(''),
      name_sort_by: this.attr(''),
      name_sort_by_confirmed: this.boolean(false),
      pseudonym: this.attr(null),
      pseudonym_sort_by: this.attr(null),
      pseudonym_sort_by_confirmed: this.boolean(false),
      published_name: this.attr(''),
      published_name_sort_by: this.attr(''),
      // missing relationships
    }
  }
}

export const personState = {
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
