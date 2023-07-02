<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column flex-grow-1">
        <h4 class="mt-3">Configuration</h4>
        <b-form-group label-cols="auto" label="Enable Clyde" class="configuration enable">
          <b-form-checkbox switch v-model="clydeEnabled" @change="patchClydeConfig()"></b-form-checkbox>
        </b-form-group>
        <b-form-group label-cols="auto" label="Use Clyde as Registration Integration" class="configuration enable ml-2">
          <b-form-checkbox switch v-model="clydeRegistration" @change="patchClydeConfig()" :disabled="!clydeEnabled"></b-form-checkbox>
        </b-form-group>
        <b-form-group label="Base URL for Clyde" class="ml-2">
          <b-form-input type="text" v-model="clydeBaseUrl" @blur="patchClydeConfig()" :disabled="!clydeEnabled"></b-form-input>
        </b-form-group>
        <b-form-group label="Button text for Log In Button" class="ml-2">
          <b-form-input type="text" v-model="clydeButtonText" @blur="patchClydeConfig()" :disabled="!clydeEnabled"></b-form-input>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import { clydeMixin } from './clyde.mixin'

export default {
  name: "ClydeSettings",
  mixins: [clydeMixin],

}
</script>

<style lang="scss">
.configuration.enable .form-row {
  align-items: center;
}
</style>
