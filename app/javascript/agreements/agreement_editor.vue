<template>
  <b-form
    ref='add-agreement-form'
  >
    <model-field label="Title" v-model="agreementData.title" type="text" stateless></model-field>
    <label>Body</label>
    <plano-editor
        v-model="agreementData.terms"
        type='classic'
        :disabled="readOnly"
    ></plano-editor>
    <!--model-field label="Terms" v-model="agreement.terms" type="text" stateless></model-field-->
    <label style="padding-right: 15px">Roles:</label><input type="radio" id="member" value="member" v-model="agreementData.target"/>
    <label for="member" style="padding-right: 15px">Members</label>
    <input type="radio" id="staff" value="staff" v-model="agreementData.target"/>
    <label for="staff" style="padding-right: 15px">Staff</label>
    <input type="radio" id="all" value="all" v-model="agreementData.target"/>
    <label for="all">All</label>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="saveAgreement">Save</b-button>
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
  name: "AgreementEditor",
  components: {
    ModelField,
    PlanoEditor
  },
  mixins: [
    toastMixin
  ],
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
  data() {
    return {
      agreementData: {
        title: '',
        terms: '',
        target: 'all'
      }
    }
  },
  methods: {
    ...mapActions({newAgreementAction: NEW_AGREEMENT}),
    clear() {
      this.agreementData.title = '';
      this.agreementData.terms = '';
      this.agreementData.target = 'all';
    },
    setAgreementData(data) {
      this.agreementData.title=data.title;
      this.agreementData.terms = data.terms;
      this.agreementData.target = data.target;
    },
    saveAgreement() {
      let res = this.newAgreementAction(this.agreementData);
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
