import { SAVE } from './model.store';
import {mapActions } from 'vuex';
import { emailAddressModel as model} from '@/store/email_address.store';
import { personModel } from '@/store/person.store';
import {GET_EMAIL_ADDRESSES, NEW_EMAIL_ADDRESS} from '@/store/email_address.store';

import {
  ADD_EMAIL_SUCCESS,
  ADD_EMAIL_ERROR,
  MODEL_SAVE_SUCCESS,
  MODEL_SAVE_ERROR
} from '../constants/strings'

import modelMixin from "./model.mixin";

export const emailAddressMixin = {
  mixins: [modelMixin],
  methods: {
    ...mapActions({
      new_email_address: NEW_EMAIL_ADDRESS,
      get_email_addresses: GET_EMAIL_ADDRESSES
    }),
    getEmailsForPerson(person) {
      return this.$store.dispatch(
        'jv/getRelated',
        `${personModel}/${person.id}/email_addresses`
      )
    },
    saveEmail(email) {
      return this.toastPromise(
        this.$store.dispatch(SAVE,
          {model: this.model, item: email}
        ),
        MODEL_SAVE_SUCCESS(this.model),
        MODEL_SAVE_ERROR(this.model)
      );
    },
    addEmail(candidate, success_text = ADD_EMAIL_SUCCESS, error_text =  ADD_EMAIL_ERROR) {
      return this.toastPromise(
        this.new_email_address(candidate),
        success_text,
        error_text
      );
    }
  }
}

export default emailAddressMixin;
