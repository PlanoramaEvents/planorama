import {BasePlanoStore} from '../model.store'
import {InformationEthicsAgreement} from './agreement';
import { http } from '../http';

export const FETCH_IEA = "FETCH INFORMATION ETHICS";
export const SAVE_IEA = "SAVE INFORMATION ETHICS";
export const SET_IEA = "SET INFORMATION ETHICS";
export const SIGN_IEA = "SIGN INFORMATION ETHICS";
export const GET_IEA_UNSIGNED = "GET INFORMATION ETHICS UNSIGNED";
export const SET_IEA_UNSIGNED = "SET INFORMATION ETHICS UNSIGNED";

export class AgreementStore extends BasePlanoStore {
  constructor() {
    super("agreements", true)
    this.state = {
      information_ethics: new InformationEthicsAgreement(),
      ieaUnsigned: true
    }
    this.mutations = {
      [SET_IEA] (state, agreement) {
        state.information_ethics = agreement;
      },
      [SET_IEA_UNSIGNED] (state, unsigned) {
        state.ieaUnsigned = unsigned
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
      },
      [GET_IEA_UNSIGNED] ({state, commit}) {
        return new Promise((res, rej) => {
          http.get('/agreement/signed.json').then((data) => {
            let agreementIds = data.data.data
            console.log('agreement ids', agreementIds)
            commit(SET_IEA_UNSIGNED, agreementIds.includes(state.information_ethics.id))
            res()
          }).catch(rej);
        })
      },
      [SIGN_IEA] ({state, commit}, {success, failure}) {
        return state.information_ethics.sign().then((data) => {
          commit(SET_IEA_UNSIGNED, false);
          console.log(data)
          success(data);
        }).catch(failure);
      }
    }
  }
}

export const store = new AgreementStore();
