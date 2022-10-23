<template>
  <div v-if="currentSettings">
    <p><strong>{{EVENT_SETTINGS_MUST_RELOAD}}</strong></p>
    <div v-for="parameter in parameters" :key="parameter.paremeter_name">
      <config-editor
        model="configuration"
        :parameter="parameter"
        v-if="parameter"
      ></config-editor>
    </div>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import ConfigEditor from './config_editor';
import settingsMixin from "@/store/settings.mixin";
import { EVENT_SETTINGS_MUST_RELOAD } from '@/constants/strings';

export default {
  name: "ConfigurationsManager",
  components: {
    ConfigEditor
  },
  data: () => ({
    parameters: [],
    loading: true,
    EVENT_SETTINGS_MUST_RELOAD
  }),
  mixins: [
    modelMixin,
    settingsMixin
  ],
  methods: {
    load_parameters() {
      this.loading = true
      // This needs to change to get sorted ...?
      this.fetch({}).then(data => {
        this.parameters = this.collection
        this.loading = false
      })
    },

    init() {
      this.load_parameters()
    }
  // },
  // mounted() {
  //   this.fetchSettings()
  }
}
</script>

<style lang="scss">
</style>
