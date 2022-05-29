<template>
  <section>
    <div class="d-flex flex-row mt-3">
      <div class="w-50 mr-2">
        <h5>Demographics <edit-button v-b-modal.person-demo-modal></edit-button></h5>
        <dl-person :fields="demoFields"></dl-person>
        <!-- <dl>
          <dt>Ethnicity</dt>
          <dd class="ml-2">{{ selected.ethnicity | na_if_empty }}</dd>
          <dt>Gender</dt>
          <dd class="ml-2">{{ selected.gender | na_if_empty }}</dd>
          <dt>Age at time of event</dt>
          <dd class="ml-2">{{ selected.age_at_convention | na_if_empty }}</dd>
          <dt>Romantic and/or sexual orientation</dt>
          <dd class="ml-2">
            {{ selected.romantic_sexual_orientation | na_if_empty }}
          </dd>
        </dl> -->
      </div>
      <div class="w-50">
        <h5>Community memberships <edit-button v-b-modal.person-community-modal></edit-button></h5>
        <dl-person :fields="communityFields"></dl-person>
        <!-- <dl>
          <dt>Experience with being “othered”</dt>
          <dd class="ml-2">{{ selected.othered | na_if_empty }}</dd>
          <dt>Member of an Indigenous community</dt>
          <dd class="ml-2">{{ selected.indigenous | na_if_empty }}</dd>
          <dt>Member of the global Black diaspora</dt>
          <dd class="ml-2">{{ selected.black_diaspora | na_if_empty }}</dd>
          <dt>
            Represent something other than a purely US-centric perspective
          </dt>
          <dd class="ml-2">
            {{ selected.non_us_centric_perspectives | na_if_empty }}
          </dd>
          <dt>Other demographic categories</dt>
          <dd class="ml-2">
            {{ selected.demographic_categories | na_if_empty }}
          </dd>
        </dl> -->
      </div>
    </div>
    <person-edit-modal id="person-demo-modal" :person="selected" :data="demoData">
      <template #modal-title>Edit Demographics - {{selected.published_name}}</template>
      <template #default="{fields}">
        <b-form-group label="Ethnicity">
          <b-form-input type="text" v-model="fields.ethnicity"></b-form-input>
        </b-form-group>
        <b-form-group label="Gender">
          <b-form-input type="text" v-model="fields.gender"></b-form-input>
        </b-form-group>
        <b-form-group label="Age at time of event">
          <b-form-input type="text" v-model="fields.age_at_convention"></b-form-input>
        </b-form-group>
        <b-form-group label="Romantic and/or sexual orientation">
          <b-form-textarea v-model="fields.romantic_sexual_orientation"></b-form-textarea>
        </b-form-group>
      </template>
    </person-edit-modal>
    <person-edit-modal id="person-community-modal" :person="selected" :data="communityData">
      <template #modal-title>Edit community memberships - {{selected.published_name}}</template>
      <template #default="{fields}">
        <b-form-group label="Experience with being &quot;othered&quot;">
          <b-form-textarea v-model="fields.othered"></b-form-textarea>
        </b-form-group>
        <b-form-group label="Member of an Indigenous community">
          <b-form-textarea v-model="fields.indigenous"></b-form-textarea>
        </b-form-group>
        <b-form-group label="Member of the global Black diaspora">
          <b-form-textarea v-model="fields.black_diaspora"></b-form-textarea>
        </b-form-group>
        <b-form-group label="Represent something other than a purely US-centric perspective">
          <b-form-textarea v-model="fields.non_us_centric_perspectives"></b-form-textarea>
        </b-form-group>
        <b-form-group label="Other demographic categories">
          <b-form-textarea v-model="fields.demographic_categories"></b-form-textarea>
        </b-form-group>
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

export default {
  name: "PersonDemographics",
  components: {
    PersonEditModal,
    EditButton,
    DlPerson
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
    modelMixinNoProp
  ],
  computed: {
    demoFields() {
      return Object.keys(this.demoData);
    },
    communityFields() {
      return Object.keys(this.communityData);
    }
  }
};
</script>

<style></style>
