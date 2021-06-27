export const SELECT = 'SELECT';
export const SAVE = 'SAVE'
export const UNSELECT = 'UNSELECT';
export const DELETE = 'DELETE';
export const EDIT = 'EDIT';
export const UNEDIT = 'UNEDIT';
export const AFTER_SAVE = 'AFTER_SAVE'

export class PlanoStore {
  constructor(collection, columns, state= {}, mutations={}, actions={}) {
    this.state = {
      selected: undefined,
      editable: false,
      collection,
      columns,
      ...state
    }
    this.mutations = {
      [SELECT] (state, item) {
        state.selected = item;
      },
      [UNSELECT] (state) {
        state.selected = undefined;
      },
      [EDIT] (state) {
        state.editable = true;
      },
      [UNEDIT] (state) {
        state.editable = false;
      },
      ...mutations
    }
    this.actions = {
      [SAVE] ({commit}, {item, unedit=false}) {
        return new Promise((res, rej) => {
          item.save().then(() => {
            console.log('saved successfully')
            if (unedit) {
              commit(UNEDIT)
            }
            commit(SELECT, item)
            res()
          }, (error) => {
            // TODO actually show this to the user
            console.log("Error saving:", error);
            rej(error)
          })
        })
      },
      [DELETE] ({commit}, item) {
        item.delete().then(() => {
          console.log('deleted successfully')
          commit(UNSELECT)
        }, (error) => {
          // TODO actually show this to the user
          console.log("Error deleting:", error);
        });
      },
      ...actions
    }
  }

  initialize(vuex) {
    return new vuex.Store(this)
  }
}
