<template>
  <div v-if="currentSettings">
      <config-editor
        model="configuration"
        :parameter="parameter"
        v-if="parameter"
      >
      <template #default="{config, onChange}">
        <slot v-bind="{config, onChange}"></slot>
      </template>
    </config-editor>
  </div>
</template>

<script>
import { modelMixinNoProp } from '../store/model.mixin';
import ConfigEditor from './config_editor';
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "SingleConfigManager",
  components: {
    ConfigEditor
  },
  props: {
    parameterName: {
      type: String,
      required: true
    }
  },
  data: () => ({
    model: 'parameter_name',
    parameter: null,
    loading: true,
  }),
  mixins: [
    modelMixinNoProp,
    settingsMixin
  ],
  methods: {
    load_parameters() {
      this.loading = true
      // This needs to change to get sorted ...?
      this.fetch({}).then(data => {
        this.parameter = this.collection.find(p => p.parameter_name === this.parameterName)
        this.loading = false
      })
    },
  },
  mounted() {
    this.fetchSettings();
    this.load_parameters();
  }
}
</script>

<style lang="scss">
</style>
