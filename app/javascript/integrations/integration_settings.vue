<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column flex-grow-1">
        <b-tabs>
          <b-tab title="Airmeet">
            <airmeet-settings></airmeet-settings>
          </b-tab>
          <b-tab title="Clyde">
            <clyde-settings></clyde-settings>
          </b-tab>
          <b-tab title="G24 RCE">
            <G24RCESettings></G24RCESettings>
          </b-tab>
        </b-tabs>
      </div>
    </div>
  </div>
</template>

<script>
import AirmeetSettings from '@/airmeet/airmeet_settings.vue'
import ClydeSettings from './clyde_settings.vue'
import G24RCESettings from './g24rce_settings.vue'

export default {
  name: "IntegrationSettings",
  components: {
    AirmeetSettings,
    ClydeSettings,
    G24RCESettings
  }
}
</script>

<style>

</style>
