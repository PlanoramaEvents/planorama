<template>
  <div class="container-fluid">
    <div class="row">
      <div class="column flex-grow-1">
        <h4 class="mt-3">Configuration</h4>
          <config-editor
            model="configuration"
            :parameter="baseUrlParameter"
            v-if="baseUrlParameter"
          ></config-editor>
      </div>
    </div>
  </div>
</template>

<script>
import ConfigEditor from '@/configurations/config_editor.vue';
import { parameterMixin } from '@/configurations/parameter.mixin';

export default {
  name: "ClydeSettings",
  mixins: [
    parameterMixin
  ],
  components: {
    ConfigEditor
  },
  computed: {
    baseUrlParameter() {
      return this.parameterByName('clyde_base_url')
    }
  },
  mounted() {
    this.fetch({});
  }
}
</script>

<style lang="scss">
</style>
