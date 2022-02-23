<template>
  <b-form
    ref='add-agreement-form'
  >
    <model-field label="Title" v-model="agreement.title" type="text" stateless></model-field>
    <plano-editor
        v-model="agreement.terms"
        type='classic'
        :disabled="readOnly"
    ></plano-editor>
    <!--model-field label="Terms" v-model="agreement.terms" type="text" stateless></model-field-->
    <input type="radio" id="member" value="member" v-model="agreement.target"/>
    <label for="member" style="padding-right: 15px">Members</label>
    <input type="radio" id="staff" value="staff" v-model="agreement.target"/>
    <label for="staff" style="padding-right: 15px">Staff</label>
    <input type="radio" id="all" value="all" v-model="agreement.target"/>
    <label for="all">All</label>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="savePerson">Save</b-button>
    </div>
  </b-form>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import { ADMIN_ADD_AGREEMENT_SUCCESS } from '@/constants/strings';
import ModelField from '../shared/model-field';
import PlanoEditor from '../components/plano_editor';

import { mapActions } from 'vuex';
import { NEW_AGREEMENT } from '@/store/agreement.store';

export default {
  name: "AgreementAdd",
  components: {
    ModelField,
    PlanoEditor
  },
  mixins: [
    toastMixin
  ],
  data: () =>  ({
    // This is minimal JSON for a new Agreement entity
    agreement: {
      title: '',
      terms: '',
      target: 'all',
    },
  }),
  props: {
    showButtons: {
      default: true,
      type: Boolean
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    ...mapActions({newAgreementAction: NEW_AGREEMENT}),
    clear() {
      this.agreement.title = '';
      this.agreement.terms = '';
      this.agreement.target = 'all';
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
