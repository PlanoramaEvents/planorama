import { FETCH, SELECT, UNSELECT } from "./model.store";

export const registrationSyncDatumModel = 'registration_sync_datum';
const model = registrationSyncDatumModel;

export const GET_REG_BY_ID = "GET REG BY ID";

export const registrationSyncDatumEndpoints = {
  [registrationSyncDatumModel]: 'registration_sync_datum'
}

export const registrationSyncDatumStore = {
  selected: {
    [registrationSyncDatumModel]: undefined
  },
  getters: {
  },
  actions: {
    [GET_REG_BY_ID] ({commit, dispatch}, {id}) {
      return new Promise((res, rej) => {
        dispatch(FETCH, {model, params: {
          // trying without the %23 here in the hope that fetch will serialize correctly
          filter: `{"op":"all","queries":[["registration_number","is","${id}"]]}`
        }}).then((data) => {
          const keys = Object.keys(data).filter(key => key !== "_jv")
          if(keys.length) {
            commit(SELECT, {model, itemOrId: keys[0]})
          } else {
            commit(UNSELECT, {model});
          }
          res(data);
        }).catch(rej);
      })
    }
  },
}
