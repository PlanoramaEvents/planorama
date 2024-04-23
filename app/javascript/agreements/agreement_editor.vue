<template>
  <b-form ref='add-agreement-form'>
    <model-field label="Tytuł" v-model="agreementData.title" type="text" stateless></model-field>
    <label>Treść</label>
    <plano-editor
        v-model="agreementData.terms"
        type='classic'
        :disabled="readOnly"
    ></plano-editor>
    <label>Typ Umowy:</label>
    <select v-model="agreementData.agreement_type" style="padding-right: 15px">
      <option v-for="type in currentSettings.agreement_types" :selected="type === selected_agreement_type">{{type}}</option>
    </select>
    <label>Target:</label>
    <select v-model="agreementData.target">
      <option v-for="role in agreement_enums" :selected="role === selected_target">{{role}}</option>
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
      selected_agreement_type: 'Warunki i Zasady',
      selected_target: 'brak'
    }
  },
  emits: ["saved"],
  computed: {
    agreement_enums: {
      get: function() {
        if (this.currentSettings && this.currentSettings.enums) {
          return this.currentSettings.enums.Agreement.target
        } else {
          return []
        }
      }
    }
  },
  methods: {
    ...mapActions({newAgreementAction: NEW_AGREEMENT}),
    clear() {
      this.agreementData.title = '';
      this.agreementData.terms = '';
      this.agreementData.agreement_type = '';
      this.agreementData.target = '';
      this.selected_agreement_type = 'Warunki i Zasady';
      this.selected_target = 'brak';
    },
    setAgreementData(data) {
      //console.log("setAgreementData: ", data);
      if(data && data.title && data.terms && data.agreement_type && data.target) {
        this.agreementData.title = data.title;
        this.agreementData.terms = data.terms;
        this.selected_agreement_type = this.agreementData.agreement_type = data.agreement_type;
        this.selected_target = this.agreementData.target = data.target;
      }
    },
    saveAgreement() {
      let res = this.newAgreementAction(this.agreementData);
      res.then(
        (obj) => {
          this.$bvToast.toast(
            ADMIN_ADD_AGREEMENT_SUCCESS(obj.title),
            {
              variant: 'success',
              title: 'Umowa utworzona'
            }
          )
          this.clear()
          this.$emit("saved");
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