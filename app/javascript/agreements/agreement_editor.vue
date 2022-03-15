<template>
  <b-form ref='add-agreement-form'>
    <model-field label="Title" v-model="agreementData.title" type="text" stateless></model-field>
    <label>Body</label>
    <plano-editor
        v-model="agreementData.terms"
        type='classic'
        :disabled="readOnly"
    ></plano-editor>
    <label>Agreement Type:</label>
    <select v-model="agreementData.agreement_type" style="padding-right: 15px">
      <option v-for="type in currentSettings.agreement_types" :selected="type === selected_agreement_type">{{type}}</option>
    </select>
    <label>Role:</label>
    <select v-model="agreementData.target">
      <option v-for="role in currentSettings.enums.Agreement.target" :selected="role === selected_target">{{role}}</option>
    </select>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="saveAgreement">Save</b-button>
    </div>
  </b-form>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import settingsMixin from "@/store/settings.mixin";
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
    toastMixin,
      settingsMixin
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
        agreement_type: '',
        target: ''
      },
      selected_agreement_type: 'Terms and Conditions',
      selected_target: 'none'
    }
  },
  methods: {
    ...mapActions({newAgreementAction: NEW_AGREEMENT}),
    clear() {
      this.agreementData.title = '';
      this.agreementData.terms = '';
      this.agreementData.agreement_type = '';
      this.agreementData.target = '';
      this.selected_agreement_type = 'Terms and Conditions';
      this.selected_target = 'none';
    },
    setAgreementData(data) {
      //console.log("setAgreementData: ", data);
      this.agreementData.title=data.title;
      this.agreementData.terms = data.terms;
      this.selected_agreement_type=this.agreementData.agreement_type = data.agreement_type;
      this.selected_target=this.agreementData.target = data.target;
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
