<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column flex-grow-1">
        <h4 class="mt-3">Configuration</h4>
        <b-form-group label-cols="auto" label="Enable G24 RCE" class="configuration enable">
          <b-form-checkbox switch v-model="g24rceEnabled" @change="patchG24RCEConfig()"></b-form-checkbox>
        </b-form-group>

        <a href="/rce/schedule" target="_blank" class="btn btn-primary">Export Sessions</a>

        <b-form-group label="Base URL for Portal" class="ml-2 mt-5">
          <b-form-input type="text" v-model="g24rceBasebPortalUrl" @blur="patchG24RCEConfig()"
            :disabled="!g24rceEnabled"></b-form-input>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import { g24rceMixin } from './g24rce.mixin'

export default {
  name: "G24RCESettings",
  mixins: [g24rceMixin]
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
