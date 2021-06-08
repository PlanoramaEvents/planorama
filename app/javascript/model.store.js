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
  },
  actions: {
    [SAVE] (context, item) {
      console.log(item)
      item.save().then(() => {
        console.log('saved successfully')
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
