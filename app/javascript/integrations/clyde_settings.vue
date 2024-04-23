<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column flex-grow-1">
        <h4 class="mt-3">Konfiguracja</h4>
        <b-form-group label-cols="auto" label="Włącz Clyde" class="konfiguracja enable">
          <b-form-checkbox switch v-model="clydeEnabled" @change="patchClydeConfig()"></b-form-checkbox>
        </b-form-group>
        <b-form-group label-cols="auto" label="Użyj Clyde jako integracji rejestracji" class="konfiguracja enable ml-2">
          <b-form-checkbox switch v-model="clydeRegistration" @change="patchClydeConfig()" :disabled="!clydeEnabled"></b-form-checkbox>
        </b-form-group>
        <b-form-group label="Adres URL podstawowy dla Clyde" class="ml-2">
          <b-form-input type="text" v-model="clydeBaseUrl" @blur="patchClydeConfig()" :disabled="!clydeEnabled"></b-form-input>
        </b-form-group>
        <b-form-group label="Tekst przycisku Log In" class="ml-2">
          <b-form-input type="text" v-model="clydeButtonText" @blur="patchClydeConfig()" :disabled="!clydeEnabled"></b-form-input>
        </b-form-group>
        <b-form-group label="Tekst linku do strony Log In" class="ml-2">
          <div class="d-flex align-items-center">
            <span class="basis-14">Możesz także zalogować się za pomocą</span> <b-form-input type="text" v-model="clydeLinkText" @blur="patchClydeConfig()" :disabled="!clydeEnabled" inline></b-form-input>
          </div>
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
.basis-14 {
  flex-basis: 14rem;
}
</style>

