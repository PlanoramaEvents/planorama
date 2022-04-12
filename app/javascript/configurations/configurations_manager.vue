<template>
  <div v-if="currentSettings">
    <div v-for="parameter in parameters">
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

export default {
  name: "ConfigurationsManager",
  components: {
    ConfigEditor
  },
  data () {
    return {
      parameters: [],
      loading: true
    }
  },
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
