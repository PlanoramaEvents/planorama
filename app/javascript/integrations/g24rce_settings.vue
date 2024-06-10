<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column flex-grow-1">
        <h4 class="mt-3">Configuration</h4>
        <b-form-group label-cols="auto" label="Enable G24 RCE" class="configuration enable">
          <b-form-checkbox switch v-model="g24rceEnabled" @change="patchG24RCEConfig()"></b-form-checkbox>
        </b-form-group>

        <b-button variant="primary" size="sm" class="ml-2" :disabled="!g24rceEnabled" @click="exportPartipants">Export
          Participants</b-button>
        <b-button variant="primary" size="sm" class="ml-2" :disabled="!g24rceEnabled" @click="exportSessions">Export
          Sessions</b-button>

        <b-form-group label="Base URL for RCE Stages" class="ml-2 mt-5">
          <b-form-input type="text" v-model="g24rceBaseStageUrl" @blur="patchClydeConfig()"
            :disabled="!g24rceEnabled"></b-form-input>
        </b-form-group>
        <b-form-group label="Base URL for RCE Sessions" class="ml-2">
          <b-form-input type="text" v-model="g24rceBaseSessionUrl" @blur="patchClydeConfig()"
            :disabled="!g24rceEnabled"></b-form-input>
        </b-form-group>
        <b-form-group label="Base URL for Participant Join" class="ml-2">
          <b-form-input type="text" v-model="g24rceBaseParticipantUrl" @blur="patchClydeConfig()"
            :disabled="!g24rceEnabled"></b-form-input>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import { g24rceMixin } from './g24rce.mixin'
import { toastMixin } from '@/mixins';
import { http } from '@/http';

export default {
  name: "G24RCESettings",
  mixins: [g24rceMixin, toastMixin],
  methods: {
    exportPartipants() {

    },
    exportSessions() {

    }
  }
}
</script>

<style lang="scss">
.configuration.enable .form-row {
  align-items: center;
}

.basis-14 {
  flex-basis: 14rem;
}
</style>
