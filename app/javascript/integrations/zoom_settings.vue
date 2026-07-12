<template>
<div class="container-fluid">
  <div class="row">
    <div class="column flex-grow-1">
      <h4 class="mt-3">Configuration</h4>
      <b-form-group label-cols="auto" label="Enable Zoom Events" class="configuration enable ml-2">
        <b-form-checkbox switch v-model="zoom_enabled" @change="patchZoomConfig()"></b-form-checkbox>
      </b-form-group>
      <b-form-group label="Id of the Zoom Event for this convention" class="ml-2">
        <b-form-input type="text" v-model="zoom_event_id" @blur="patchZoomConfig()" :disabled="!zoom_enabled"></b-form-input>
      </b-form-group>
      <b-form-group label="Id of the Zoom Account" class="ml-2">
        <b-form-input type="text" v-model="zoom_account_id" @blur="patchZoomConfig()" :disabled="!zoom_enabled"></b-form-input>
      </b-form-group>
      <b-form-group label="Id of the Zoom client" class="ml-2">
        <b-form-input type="text" v-model="zoom_client_id" @blur="patchZoomConfig()" :disabled="!zoom_enabled"></b-form-input>
      </b-form-group>
      <b-form-group label="Zoom Client Secret" class="ml-2">
        <b-form-input type="text" v-model="zoom_client_secret" @blur="patchZoomConfig()" :disabled="!zoom_enabled"></b-form-input>
      </b-form-group>
    </div>
  </div>
</div>
</template>

<script>
import { zoomMixin } from './zoom.mixin'
// import PlanoModal from '@/components/plano_modal.vue';
import { toastMixin } from '@/mixins';
// import { http } from '@/http';

export default {
  name: "zoomSettings",
  mixins: [zoomMixin, toastMixin],
  components: {
    // PlanoModal,
    // RegSyncModal
  },
  methods: {
    // synchronizeSchedule() {
    //   this.toastPromise(http.get('/registration_sync_data/synchronize'), "Succesfully requested registration sync").then(() => {
    //     this.fetchStats();
    //   })
    // },
  },
  mounted() {
    // this.fetchStats();
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
