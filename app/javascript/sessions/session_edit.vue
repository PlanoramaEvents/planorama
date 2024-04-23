<template>
  <div class="detail container-fluid">
    <div class="row">
      <div class="col-12">
        <h2>Informacje podstawowe</h2>
        <b-form-group
          label="Interest Instructions"
        >
          <plano-editor
            id="interest-instructions-text"
            v-model="session.instructions_for_interest"
            type='classic'
            @change="saveSession()"
          ></plano-editor>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">

        <pill-display 
          v-model="session_areas"
          @input="saveSession()"
          label="Areas"
          color="primary"
          :modalOptions="areaOptions"
          :formatter="areaFormatter"
        ></pill-display>
      </div>
      <div class="col-6">
        <b-form-group
          label="Format"
        >
          <model-select
            id="session-format"
            v-model="session.format_id"
            model="format"
            field="name"
            :multiple="false"
            @change="saveSession()"
            :selectSize="4"
          ></model-select>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Session Environment">
          <b-form-radio-group
            id="session-environment"
            stacked
            v-model="session.environment"
            @change="saveSession()"
            v-if="currentSettings && currentSettings.enums"
          >
            <b-form-radio v-for="env in currentSettings.enums.Session.environment" :value="env"  v-bind:key="env">{{SESSION_ENVIRONMENT[env]}}</b-form-radio>
          </b-form-radio-group>
        </b-form-group>
      </div>
      <div class="col-6">
        <b-form-group
          label="Room Setup"
        >
          <model-select
            id="session-room-setup"
            v-model="session.room_set_id"
            model="room_set"
            field="name"
            :multiple="false"
            @change="saveSession()"
            :selectSize="4"
          ></model-select>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Attendee Signup Required" class="form-inline mb-4">
          <span>No</span>
          <b-form-checkbox  id="session-attendee-signup-req" inline switch v-model="session.require_signup" @change="saveSession()">Yes</b-form-checkbox>
          <label :class="['ml-2', {'text-muted': !session.require_signup}]">Jeśli tak, maksymalna liczba miejsc:
            <ValidationProvider v-slot="validationCtx" rules="min_value:1">
              <b-form-input
                id="session-max-signups"
                type="number"
                class="ml-1"
                :disabled="!session.require_signup"
                v-model="session.audience_size"
                @blur="saveValidatedSession(validationCtx)"
                :state="getValidationState(validationCtx)"
                ></b-form-input>
              <b-form-invalid-feedback>{{ validationCtx.errors[0] }}</b-form-invalid-feedback>
            </ValidationProvider>
          </label>
        </b-form-group>
      </div>
      <div class="col-6">
        <pill-display 
          v-model="session.tag_list"
          @input="saveSession()"
          label="Public Tags"
          color="warning"
          :modalOptions="sessionTagsOptions"
        ></pill-display>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <b-form-group label="Attendee Age Restrictions">
          <b-form-radio-group id="session-age-restriction" stacked name="age_restriction" :options="ageRestrictionOptions" v-model="session.age_restriction_id" @change="saveSession()"></b-form-radio-group>
        </b-form-group>
      </div>
      <div class="col-6">
        <pill-display
          v-model="session.label_list"
          @input="saveSession()"
          label="Admin Labels"
          color="info"
          :modalOptions="sessionLabelsOptions"
        ></pill-display>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Minors Participation">
          <b-form-checkbox-group id="session-minor-participation" stacked :options="minorsParticipationOptions" v-model="minors_participation" @change="saveSession()" name="minors_participation">
          </b-form-checkbox-group>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Required Room Features/Services">
          <b-textarea id="session-room-feature" v-model="session.room_notes" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group
          label="Scheduled Participant Notes"
        >
          <plano-editor
            id="scheduled-participant-text"
            v-model="session.participant_notes"
            type='classic'
            @change="saveSession()"
          ></plano-editor>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Tech/Hotel Notes">
          <b-textarea id="session-tech-notes" v-model="session.tech_notes" @blur="saveSession()"></b-textarea>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import { sessionModel } from '@/store/session.store'
import modelUtilsMixin from '@/store/model_utils.mixin';
import ModelSelect from '../components/model_select';
import ModelTags from '../components/model_tags';
import PlanoEditor from '@/components/plano_editor';
import { ValidationProvider, extend } from 'vee-validate';
import { min_value } from 'vee-validate/dist/rules'
import { SESSION_ENVIRONMENT } from '@/constants/strings'
import {minorsParticipationMixin} from './minors_participation.mixin';
import { ageRestrictionMixin } from './age_restriction.mixin';
import PillDisplay from '@/components/pill_display.vue';
import { tagsMixin } from '@/store/tags.mixin';
import { areaMixin } from '@/store/area.mixin';

extend('min_value', {
  ...min_value,
  message: "This value can't be less than 1"
  })

export default {
  name: "SessionEdit",
  components: {
    ModelSelect,
    ModelTags,
    PlanoEditor,
    ValidationProvider,
    PillDisplay,
  },
  mixins: [
    modelUtilsMixin,
    minorsParticipationMixin,
    ageRestrictionMixin,
    tagsMixin,
    areaMixin,
  ],
  data: () => ({
    editable: false,
    saving: false,
    SESSION_ENVIRONMENT,
  }),
  computed: {
    session() {
      return this.selected_model(sessionModel)
    },
    session_areas: {
      get() {
        let res = Object.values(this.session.session_areas).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
              obj.area_id
          )
        )

        return res
      },
      set(val) {
        let existingAreas = Object.values(this.session.session_areas)
        let newAreas = val;
        let areasForSaving = [];
        for (let area of newAreas) {
          let existing = existingAreas.find(r => r.area.id === area);
          if(existing) {
            areasForSaving.push(this.buildArea(existing));
          } else {
            areasForSaving.push({area_id: area})
          }
        }
        for (let area of existingAreas) {
          if(!newAreas.includes(area.area.id)) {
            areasForSaving.push({...this.buildArea(area), _destroy: 1})
          }
        }

        this.session.session_areas_attributes = areasForSaving
      }
    },
  },
  methods: {
    edit() {
      this.editable = true
    },
    buildArea(v) {
      return {
        id: v.id,
        area_id: v.area.id
      }
    },
    saveSession() {
      this.save_model(sessionModel, this.session)
    },
    saveValidatedSession({dirty, valid=null}) {
      if(dirty && valid) {
        this.save_model(sessionModel, this.session)
      }
    },
    getValidationState({ dirty, validated, valid = null }) {
      return dirty || validated ? valid : null;
    },
  }
}
</script>

<style>

</style>
