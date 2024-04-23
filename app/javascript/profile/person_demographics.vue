<template>
  <section>
    <div class="d-flex flex-row mt-3">
      <div class="w-50 mr-2">
        <h5>Dane demograficzne <edit-button v-b-modal.person-demo-modal v-if="canEditInfo && !readOnly"></edit-button></h5>
        <dl-person :fields="demoFields" v-if="showDemoAndCommunity"></dl-person>
        <div v-else>Wkrótce</div>
      </div>
      <div class="w-50">
        <h5>Członkostwo w społecznościach <edit-button v-b-modal.person-community-modal v-if="canEditInfo && !readOnly"></edit-button></h5>
        <dl-person :fields="communityFields" v-if="showDemoAndCommunity"></dl-person>
        <div v-else>Wkrótce</div>
      </div>
    </div>
    <person-edit-modal id="person-demo-modal" :person="selected" :data="demoData" :validate="true">
      <template #modal-title>Edytuj dane demograficzne - {{selected.published_name}}</template>
      <template #default="{fields}">
        <validation-provider v-if="!isHidden('ethnicity')">
          <b-form-group :label="PROFILE_FIELD_LABELS.ethnicity">
            <b-form-input type="text" v-model="fields.ethnicity"></b-form-input>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('gender')">
          <b-form-group :label="PROFILE_FIELD_LABELS.gender">
            <b-form-input type="text" v-model="fields.gender"></b-form-input>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('age_at_convention')">
          <b-form-group :label="PROFILE_FIELD_LABELS.age_at_convention">
            <b-form-input type="text" v-model="fields.age_at_convention"></b-form-input>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('romantic_sexual_orientation')">
          <b-form-group :label="PROFILE_FIELD_LABELS.romantic_sexual_orientation">
            <b-form-textarea v-model="fields.romantic_sexual_orientation"></b-form-textarea>
          </b-form-group>
        </validation-provider>
      </template>
    </person-edit-modal>
    <person-edit-modal id="person-community-modal" :person="selected" :data="communityData" :validate="true">
      <template #modal-title>Edytuj członkostwo w społecznościach - {{selected.published_name}}</template>
      <template #default="{fields}">
        <validation-provider v-if="!isHidden('othered')">
          <b-form-group :label="PROFILE_FIELD_LABELS.othered">
            <b-form-textarea v-model="fields.othered"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('indigenous')">
          <b-form-group :label="PROFILE_FIELD_LABELS.indigenous">
            <b-form-textarea v-model="fields.indigenous"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('black_diaspora')">
          <b-form-group :label="PROFILE_FIELD_LABELS.black_diaspora">
            <b-form-textarea v-model="fields.black_diaspora"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('global_diaspora')">
          <b-form-group :label="PROFILE_FIELD_LABELS.global_diaspora">
            <b-form-textarea v-model="fields.global_diaspora"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('non_anglophone')">
          <b-form-group :label="PROFILE_FIELD_LABELS.non_anglophone">
            <b-form-textarea v-model="fields.non_anglophone"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('non_us_centric_perspectives')">
          <b-form-group :label="PROFILE_FIELD_LABELS.non_us_centric_perspectives">
            <b-form-textarea v-model="fields.non_us_centric_perspectives"></b-form-textarea>
          </b-form-group>
        </validation-provider>
        <validation-provider v-if="!isHidden('demographic_categories')">
          <b-form-group :label="PROFILE_FIELD_LABELS.demographic_categories">
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
import { settingsMixin } from "@/mixins";
import { peopleHiddenFieldsMixin } from '@/configurations/people_hidden_fields.mixin';
import { PROFILE_FIELD_LABELS } from "@/constants/strings";

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
      global_diaspora: null,
      non_anglophone: null,
      non_us_centric_perspectives: null,
      demographic_categories: null,
    },
    PROFILE_FIELD_LABELS,
  }),
  mixins: [
    modelMixinNoProp,
    personSessionMixin,
    settingsMixin,
    peopleHiddenFieldsMixin
  ],
  computed: {
    demoFields() {
      return this.filterFieldList(Object.keys(this.demoData));
    },
    communityFields() {
      return this.filterFieldList(Object.keys(this.communityData));
    },
    canEditInfo() {
      // TODO use sensitive data permission in the future
      return (this.currentUserIsAdmin || this.currentUser.id === this.selected.id) && this.showDemoAndCommunity;
    },
    showDemoAndCommunity() {
      return (this.configByName('profile_show_info_demographic_community') !== "false")
    }
  }
};
</script>

<style></style>
