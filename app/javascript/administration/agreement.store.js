import {BasePlanoStore} from '../model.store'
import {InformationEthicsAgreement} from './agreement';

export const FETCH_IEA = "FETCH INFORMATION ETHICS";
export const SAVE_IEA = "SAVE INFORMATION ETHICS";
export const SET_IEA = "SET INFORMATION ETHICS";

export class AgreementStore extends BasePlanoStore {
  constructor() {
    super("agreements", true)
    this.state = {
      information_ethics: new InformationEthicsAgreement()
    }
    this.mutations = {
      [SET_IEA] (state, agreement) {
        state.information_ethics = agreement;
      }
    }
    this.actions = {
      [FETCH_IEA] ({state, commit}) {
        state.information_ethics.fetch().then((resp) => {
        }).catch((error) => {
          commit(SET_IEA, new InformationEthicsAgreement())
        })
      },
      [SAVE_IEA] ({state, commit}, {success, failure}) {
        if(state.information_ethics.changed()) {
          let new_iea = new InformationEthicsAgreement({terms: state.information_ethics.terms})
          commit(SET_IEA, new_iea)
          new_iea.save().then(success).catch(failure)
        }
      }
    }
  }
}

export const store = new AgreementStore();
