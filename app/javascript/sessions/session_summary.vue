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
          </b-form-checkbox>
          <!--
            TODO: we need the date when the session was opened for interest .... ????
            This is a new requirement?!?
          -->
        </b-form-group>
      </div>
      <div class='ml-auto' v-if="session">
        <!-- TODO: update details here -->
        <small class="text-muted d-block">
          Last updated:
        </small>
        <!-- <small class="text-muted d-block"> by <em><strong>{{selected.updated_by && selected.updated_by.name}}</strong></em></small> -->
        <small class="text-muted d-block">
          Last edited on:
          <em><strong>

            {{new Date(session.updated_at).toLocaleString()}}
          </strong></em>
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
