<template>
  <sidebar-vuex v-bind="{namespace}">
    <template #header v-if="selected">
      <h1 class="title">{{ selected[titleField] || selected[Object.keys(fields)[0]] }}</h1>
    </template>
    <template #content v-if="selected">
      <template v-if="pulledFields">
          <slot v-for="({label, type}, field) in upperFields" :name="field" v-bind="{label, type, value: selected[field], field, selected}">
            <model-field :label="label" v-model="selected[field]" :key="field" :type="type"></model-field>
          </slot>
      </template>
      <b-tabs content-class="mt-3">
        <b-tab title="Details" active>
          <edit-button></edit-button>
          <save-button></save-button>
          <slot v-for="({label, type}, field) in fields" :name="field" v-bind="{label, type, value: selected[field], field, selected}">
            <model-field :label="label" v-model="selected[field]" :key="field" :type="type"></model-field>
          </slot>
        </b-tab>
        <slot name="tabs" v-bind="{selected}">
        </slot>
      </b-tabs>
    </template>
  </sidebar-vuex>
</template>

<script>
import SidebarVuex from './sidebar_vuex';
import { mapState } from 'vuex';
import ModelField from './shared/model-field';
import EditButton from './edit-button';
import SaveButton from './save-button'

export default {
  name: 'ModelSidebar',
  props: {
    titleField: {
      type: String
    },
    pulledFields: {
      type: Array,
      default: () => []
    },
    namespace: {
      type: String,
      default: null
    }
  },
  components: {
    SidebarVuex,
    ModelField,
    EditButton,
    SaveButton,
  },
  computed: {
    ...mapState(['selected']),
    rawSchema() {
      return this.selected?.schema()
    },
    upperFields() {
      return this.pulledFields.reduce((p, c) => Object.assign(p, {[c]: this.rawSchema[c]}), {})
    },
    fields() {
      const keysToKeep = Object.keys(this.rawSchema).filter(k => !this.pulledFields.includes(k))
      return keysToKeep.reduce((p, c) => Object.assign(p, {[c]: this.rawSchema[c]}), {})
    },
  },
}
</script>
