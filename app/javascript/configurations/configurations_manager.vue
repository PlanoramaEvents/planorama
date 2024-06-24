<template>
  <div v-if="currentSettings">
    <b-alert show variant="warning">{{EVENT_SETTINGS_MUST_RELOAD}}</b-alert>
    <div v-for="parameter in parameters" :key="parameter.parameter_name">
      <config-editor
        model="configuration"
        :parameter="parameter"
        v-if="parameter && !exclusions.includes(parameter.parameter_name)"
      ></config-editor>
    </div>
    <b-alert show variant="warning">{{EVENT_SETTINGS_MUST_RELOAD}}</b-alert>
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
    EVENT_SETTINGS_MUST_RELOAD,
    // TODO
    exclusions: ['clyde_base_url', 'show_join_links']
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
