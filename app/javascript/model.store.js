export const SELECT = 'SELECT';
export const SAVE = 'SAVE'
export const UNSELECT = 'UNSELECT';
export const DELETE = 'DELETE';
export const EDIT = 'EDIT';
export const UNEDIT = 'UNEDIT';

export class PlanoStore {
  constructor(collection, columns) {
    this.state = {
      selected: undefined,
      editable: false,
      collection,
      columns,
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
      }
    }
    this.actions = {
      [SAVE] (context, item) {
        console.log(item)
        item.save().then(() => {
          console.log('saved successfully')
          context.commit(UNEDIT)
        }, (error) => {
          // TODO actually show this to the user
          console.log("Error saving:", error);
        })
      },
      [DELETE] (context, item) {
        item.delete().then(() => {
          console.log('deleted successfully')
        }, (error) => {
          // TODO actually show this to the user
          console.log("Error deleting:", error);
        });
      }
    }
  }

  initialize(vuex) {
    return new vuex.Store(this)
  }
}
