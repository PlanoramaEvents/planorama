export const SELECT = 'SELECT';
export const SAVE = 'SAVE'
export const UNSELECT = 'UNSELECT';
export const DELETE = 'DELETE';

export const store = {
  state: {
    selected: undefined,
    collection: [],
    columns: []
  },
  mutations: {
    [SELECT] (state, item) {
      state.selected = item;
    },
    [UNSELECT] (state) {
      state.selected = undefined;
    },
    [SAVE] (state, item) {
      state = {...state, collection: [
        ...state.collection.filter(i => i.id !== item.id),
        item
      ] }
    },
    [DELETE] (state, item) {
      state = {...state, collection: [
        ...state.collection.filter(i => i.id !== item.id)
      ]}
    }
  },
  actions: {
    [SAVE] (context, item) {
      item.save().then(() => {
        console.log('saved successfully')
        context.commit(SAVE, item)
      }, (error) => {
        // TODO actually show this to the user
        console.log("Error saving:", error);
      })
    },
    [DELETE] (context, item) {
      item.delete().then(() => {
        console.log('deleted successfully')
        context.commit(DELETE, item)
      }, (error) => {
        // TODO actually show this to the user
        console.log("Error deleting:", error);
      });
    }
  }
}
