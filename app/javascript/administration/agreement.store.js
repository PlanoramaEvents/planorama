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
      [FETCH_IEA] ({state}) {
        state.information_ethics.fetch().then((resp) => {
          console.log('what is this response', resp)
        }).catch((error) => {
          console.log(error);
        })
      },
      [SAVE_IEA] ({state}) {
        state.information_ethics.save().then((resp) => {
          console.log('how about this response', resp)
        })
      }
    }
  }
}

export const store = new AgreementStore();
