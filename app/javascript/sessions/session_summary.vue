<template>
  <div class="pb-3" v-if="session">
    <div class='d-flex'>
      <div class='w-75'>
        <b-form-group
          class="mx-3"
          id="session-title-group"
          label="Session Title"
          label-for="session-title"
        >
          <b-form-input
            id="session-title"
            type="text"
            v-model="session.title"
            @blur="saveSession()"
          ></b-form-input>
        </b-form-group>
        <b-form-group
          class="mx-3"
          id="session-description-group"
          label="Session Description"
          label-for="session-description"
        >
          <plano-editor
              id="session-description"
              v-model="session.description"
              type='classic'
              :height="100"
              @change="saveSession()"
          ></plano-editor>
        </b-form-group>
        <b-form-group class="mx-3">
          <b-form-checkbox
            switch
            v-model="session.open_for_interest"
            @change="saveSession()"
          >
            Open for Interest
            <span v-if="session.open_for_interest">
              on {{ session.interest_opened_at ? new Date(session.interest_opened_at).toLocaleString() : 'n/a'}}
              by {{ session.interest_opened_by ? session.interest_opened_by.toLocaleString() : 'n/a'}}
            </span>
          </b-form-checkbox>
          <!--
            TODO: we need the date when the session was opened for interest .... ????
            This is a new requirement?!?
          -->
        </b-form-group>
      </div>
      <div class='ml-auto' v-if="session">
        <small class="text-muted d-block">
          Last updated:
          <em><strong>{{session.updated_by}}</strong></em>
        </small>
        <small class="text-muted d-block">
          Last edited on:
          <em><strong>{{new Date(session.updated_at).toLocaleString()}}</strong></em>
        </small>
      </div>
    </div>
  </div>
</template>

<script>
import { sessionModel } from '@/store/session.store'
import modelUtilsMixin from '@/store/model_utils.mixin';

import PlanoEditor from '../components/plano_editor';

export default {
  name: "SessionSummary",
  components: {
    PlanoEditor
  },
  model: {
    prop: 'session'
  },
  props: {
    session: {
      type: Object,
      required: true
    }
  },
  mixins: [
    modelUtilsMixin
  ],
  methods: {
    saveSession() {
      this.save_model(sessionModel, this.session).then(
        (obj) => {
          this.$emit('input',obj)
        }
      )
    }
  }
}
</script>

<style>

</style>
