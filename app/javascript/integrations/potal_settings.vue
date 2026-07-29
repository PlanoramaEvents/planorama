<template>
<div class="container-fluid">
  <div class="row">
    <div class="column flex-grow-1">
      <h4 class="mt-3">Configuration</h4>
      <b-form-group label-cols="auto" label="Enable Portal" class="configuration enable ml-2">
        <b-form-checkbox switch v-model="portal_enabled" @change="patchPortalConfig()"></b-form-checkbox>
      </b-form-group>
      <b-form-group label="Base URL for the Portal" class="ml-2">
        <b-form-input type="text" v-model="portal_base_url" @blur="patchPortalConfig()" :disabled="!portal_enabled"></b-form-input>
      </b-form-group>
      <b-form-group label="API key for the Portal" class="ml-2">
        <b-form-input type="text" v-model="portal_api_key" @blur="patchPortalConfig()" :disabled="!portal_enabled"></b-form-input>
      </b-form-group>
    </div>
  </div>
</div>
</template>

<script>
import { portalMixin } from './portal.mixin'
import { toastMixin } from '@/mixins';

export default {
  name: "portalSettings",
  mixins: [portalMixin, toastMixin]
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
