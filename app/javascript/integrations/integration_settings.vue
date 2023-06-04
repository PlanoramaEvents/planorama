<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column">
        <b-tabs>
          <b-tab title="Airmeet">
            <airmeet-settings></airmeet-settings>
          </b-tab>
          <b-tab title="Clyde">
            <clyde-settings></clyde-settings>
          </b-tab>
        </b-tabs>
      </div>
    </div>
  </div>
</template>

<script>
import AirmeetSettings from '@/airmeet/airmeet_settings.vue'
import ClydeSettings from './clyde_settings.vue'

export default {
  name: "IntegrationSettings",
  components: {
    AirmeetSettings,
    ClydeSettings
  }
}
</script>

<style>

</style>
