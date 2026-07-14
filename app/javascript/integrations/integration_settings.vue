<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column flex-grow-1">
        <b-tabs>
          <b-tab title="Airmeet">
            <airmeet-settings></airmeet-settings>
          </b-tab>
          <b-tab title="Registration">
            <registration-settings></registration-settings>
          </b-tab>
          <b-tab title="Zoom">
            <zoom-settings></zoom-settings>
          </b-tab>
          <b-tab title="Portal">
            <portal-settings></portal-settings>
          </b-tab>
        </b-tabs>
      </div>
    </div>
  </div>
</template>

<script>
import AirmeetSettings from '@/airmeet/airmeet_settings.vue'
import RegistrationSettings from './registration_settings.vue'
import zoomSettings from './zoom_settings.vue'
import portalSettings from './potal_settings.vue'

export default {
  name: "IntegrationSettings",
  components: {
    AirmeetSettings,
    RegistrationSettings,
    zoomSettings,
    portalSettings
  }
}
</script>

<style>

</style>
