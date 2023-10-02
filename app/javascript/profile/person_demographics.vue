<template>
  <section>
    <div class="d-flex flex-row mt-3">
      <div class="w-50 mr-2">
        <h5>Demographics <edit-button v-b-modal.person-demo-modal v-if="canEditInfo && !readOnly"></edit-button></h5>
        <dl-person :fields="demoFields"></dl-person>
      </div>
      <div class="w-50">
        <h5>Community memberships <edit-button v-b-modal.person-community-modal v-if="canEditInfo && !readOnly"></edit-button></h5>
        <dl-person :fields="communityFields"></dl-person>
      </div>
    </div>
    <person-edit-modal id="person-demo-modal" :person="selected" :data="demoData" :validate="true">
      <template #modal-title>Edit Demographics - {{selected.published_name}}</template>
      <template #default="{fields}">
        <validation-provider>
          <b-form-group label="Ethnicity">
            <b-form-input type="text" v-model="fields.ethnicity"></b-form-input>
          </b-form-group>
        </validation-provider>
        <validation-provider>
          <b-form-group label="Gender">
            <b-form-input type="text" v-model="fields.gender"></b-form-input>
          </b-form-group>
        </validation-provider>
        <validation-provider>
          <b-form-group label="Age at time of event">
            <b-form-input type="text" v-model="fields.age_at_convention"></b-form-input>
          </b-form-group>
        </validation-provider>
        <validation-provider>
          <b-form-group label="Romantic and/or sexual orientation">
            <b-form-textarea v-model="fields.romantic_sexual_orientation"></b-form-textarea>
          </b-form-group>
        </validation-provider>
      </template>
    </person-edit-modal>
    <person-edit-modal id="person-community-modal" :person="selected" :data="communityData" :validate="true">
      <template #modal-title>Edit community memberships - {{selected.published_name}}</template>
      <template #default="{fields}">
        <validation-provider>
          <b-form-group label="Experience with being &quot;othered&quot;">
            <b-form-textarea v-model="fields.othered"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider>
          <b-form-group label="Member of an Indigenous community">
            <b-form-textarea v-model="fields.indigenous"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider>
          <b-form-group label="Member of the global Black diaspora">
            <b-form-textarea v-model="fields.black_diaspora"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider>
          <b-form-group label="Represent something other than a purely US-centric perspective">
            <b-form-textarea v-model="fields.non_us_centric_perspectives"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider>
          <b-form-group label="Other demographic categories">
            <b-form-textarea v-model="fields.demographic_categories"></b-form-textarea>
          </b-form-group>
        </validation-provider>
      </template>
    </person-edit-modal>
  </section>
</template>

<script>
import { modelMixinNoProp } from "@/mixins";
import { personModel as model } from "@/store/person.store";

import PersonEditModal from "./person_edit_modal.vue";
import EditButton from '@/components/edit_button';
import DlPerson from './dl_person.vue';
import personSessionMixin from '@/auth/person_session.mixin';
import { ValidationProvider } from 'vee-validate';

export default {
  name: "PersonDemographics",
  props: {
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  components: {
    PersonEditModal,
    EditButton,
    DlPerson,
    ValidationProvider,
  },
  data: () => ({
    model,
    demoData: {
      ethnicity: null,
      gender: null,
      age_at_convention: null,
      romantic_sexual_orientation: null
    },
    communityData: {
      othered: null,
      indigenous: null,
      black_diaspora: null,
      non_us_centric_perspectives: null,
      demographic_categories: null
    }
  }),
  mixins: [
    modelMixinNoProp,
    personSessionMixin
  ],
  computed: {
    demoFields() {
      return Object.keys(this.demoData);
    },
    communityFields() {
      return Object.keys(this.communityData);
    },
    canEditInfo() {
      // TODO use sensitive data permission in the future
      return this.currentUserIsAdmin || this.currentUser.id === this.selected.id;
    }
  }
};
</script>

<style></style>
