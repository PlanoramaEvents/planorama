<template>
  <div class="detail container-fluid">
    <div class="row">
      <div class="col-12">
        <h2>Basic Information</h2>
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

        <b-form-group
          label="Areas"
        >
          <model-select
            v-model="session_areas"
            model="area"
            field="name"
            :multiple="true"
            @change="saveSession()"
          ></model-select>
        </b-form-group>
        <!--
        <b-form-group
          label="Tags"
        >
          <model-tags
            :taggable="true"
            v-model="session_tags"
            model="tag"
            field="name"
            fieldOnly=true
            filter='{"op":"all","queries":[["taggings.taggable_type", "=", "Session"]]}'
            disabled
          ></model-tags>
        </b-form-group>
        -->
      </div>
      <div class="col-6">
        <b-form-group
          label="Format"
        >
          <model-select
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
      <div class="col-12">
        <b-form-group label="Session Environment">
          <b-form-radio-group
            stacked
            v-model="session.environment"
            @change="saveSession()"
          >
            <b-form-radio value="unknown">{{SESSION_ENVIRONMENT.unknown}}</b-form-radio>
            <b-form-radio value="in_person">{{SESSION_ENVIRONMENT.in_person}}</b-form-radio>
            <b-form-radio value="hybrid">{{SESSION_ENVIRONMENT.hybrid}}</b-form-radio>
            <b-form-radio value="virtual">{{SESSION_ENVIRONMENT.virtual}}</b-form-radio>
          </b-form-radio-group>
        </b-form-group>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <b-form-group label="Attendee Signup Required" class="form-inline my-4">
          <span>No</span>
          <b-form-checkbox inline switch v-model="session.require_signup" @change="saveSession()">Yes</b-form-checkbox>
          <label :class="['ml-2', {'text-muted': !session.require_signup}]">If yes, max openings:
            <ValidationProvider v-slot="validationCtx" rules="min_value:1">
              <b-form-input
                type="number"
                class="ml-1"
                :disabled="!session.require_signup"
                v-model="session.maximum_people"
                @blur="saveValidatedSession(validationCtx)"
                :state="getValidationState(validationCtx)"
                ></b-form-input>
              <b-form-invalid-feedback>{{ validationCtx.errors[0] }}</b-form-invalid-feedback>
            </ValidationProvider>
          </label>
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
          <b-textarea v-model="session.tech_notes" @blur="saveSession()"></b-textarea>
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
    ValidationProvider
  },
  mixins: [
    modelUtilsMixin
  ],
  data: () => ({
    editable: false,
    saving: false,
    SESSION_ENVIRONMENT
  }),
  computed: {
    session() {
      return this.selected_model(sessionModel)
    },
    session_tags: {
      get() {
        return this.session.tag_list
      },
      set(val) {
        this.session.tag_list = val
      }
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
