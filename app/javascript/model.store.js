export const SELECT = 'SELECT';
export const SAVE = 'SAVE'
export const UNSELECT = 'UNSELECT';
export const DELETE = 'DELETE';
export const EDIT = 'EDIT';
export const UNEDIT = 'UNEDIT';
export const AFTER_SAVE = 'AFTER_SAVE'
export const UPDATED = 'UPDATED';
export const DUPLICATE = 'DUPLICATE';

export class BasePlanoStore {
  constructor(moduleName, namespaced = false) {
    this.moduleName = moduleName;
    this.namespaced = namespaced;
  }
  initialize(vuex) {
    return new vuex.Store(this)
  }

  registerAsModuleFor(store) {
    console.log('namespaced', this.namespaced)
    store.registerModule(this.moduleName, this);
  }
}

export class PlanoStore extends BasePlanoStore{
  constructor(moduleName, collection, columns, state= {}, mutations={}, actions={}, namespaced = false) {
    super(moduleName, namespaced)
    this.state = {
      selected: undefined,
      editable: false,
      collection,
      columns,
      ...state
    };
    this.mutations = {
      [SELECT] (state, item) {
        state.selected = item;
      },
      [UNSELECT] (state) {
        state.selected = undefined;
      },
      [UPDATED] (state, collection) {
        state.collection = collection
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
            res(item)
          }, (error) => {
            // TODO actually show this to the user
            console.log("Error saving:", error);
            rej(error)
          })
        })
      },
      [DELETE] ({commit}, {item}) {
        return new Promise((res, rej) => {
          console.log("trying to delete", item)
          commit(UNSELECT);
          item.delete().then(() => {
            console.log('deleted successfully')
            res()
          }, (error) => {
            console.log("Error deleting:", error);
            rej(error)
          });
        })
      },
      [DUPLICATE] ({state}, {item}) {
        return new Promise((res, rej) => {
          let copy = item.duplicate();
          copy.registerCollection(state.collection);
          copy.save().then(() => {
            res(copy)
          }, (error) => {
            console.log("Error duplicating:", error)
            rej(error)
          })
        });
      },
      ...actions
    }
  }

  helpers() {
    // figure out later
  }
}
