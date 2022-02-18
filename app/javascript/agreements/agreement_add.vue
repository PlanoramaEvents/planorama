<template>
  <b-form
    ref='add-agreement-form'
  >
    <model-field label="Title" v-model="agreement.title" type="text" stateless></model-field>
    <model-field label="Terms" v-model="agreement.terms" type="text" stateless></model-field>
    <model-field label="Target" v-model="agreement.target" type="text" stateless></model-field>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="savePerson">Save</b-button>
    </div>
  </b-form>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import { ADMIN_ADD_AGREEMENT_SUCCESS } from '../constants/strings';
import ModelField from '../shared/model-field';

import { mapActions } from 'vuex';
import { NEW_AGREEMENT } from '../store/agreement.store';

export default {
  name: "AgreementAdd",
  components: {
    ModelField,
  },
  mixins: [
    toastMixin
  ],
  data: () =>  ({
    // This is minimal JSON for a new Agreement entity
    agreement: {
      title: '',
      terms: '',
      target: '',
    },
  }),
  props: {
    showButtons: {
      default: true,
      tyep: Boolean
    }
  },
  methods: {
    ...mapActions({newAgreementAction: NEW_AGREEMENT}),
    clear() {
      this.agreement.title = '';
      this.agreement.terms = '';
      this.agreement.target = '';
    },
    savePerson() {
      let res = this.newAgreementAction(this.agreement);
      res.then(
        (obj) => {
          this.$bvToast.toast(
            ADMIN_ADD_AGREEMENT_SUCCESS(obj.title),
            {
              variant: 'success',
              title: 'Agreement Created'
            }
          )
          this.clear()
        }
      ).catch(
        (err) => {
          this.$bvToast.toast(
            err.response.data.errors[0].title,
            {
              variant: 'danger',
              title: err.response.data.errors[0].title
            }
          )
        }
      );
    }
  }
}
</script>

<style>

</style>
