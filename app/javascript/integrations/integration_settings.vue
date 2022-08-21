<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column">
        <b-tabs>
          <b-tab title="Airmeet">
            <airmeet-settings></airmeet-settings>
          </b-tab>
        </b-tabs>
      </div>
    </div>
  </div>
</template>

<script>
import AirmeetSettings from '@/airmeet/airmeet_settings.vue'

export default {
  name: "IntegrationSettings",
  components: {
    AirmeetSettings
  }
}
</script>

<style>

</style>
