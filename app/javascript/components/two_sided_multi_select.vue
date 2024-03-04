<template>
  <div class="d-flex w-100 p-3">
    <div class="d-flex flex-column w-100">
      <label :for="idA">{{ notSelectedLabel }}</label>
      <b-select :id="idA" multiple :select-size="7" class="w-100" :options="optionsA" v-model="selectedA"></b-select>
    </div>
    <div class="d-flex flex-column justify-content-center p-2 mt-4">
      <button class="btn btn-primary m-2" :disabled="!selectedA.length" @click="moveToB()"><b-icon-chevron-right></b-icon-chevron-right></button>
      <button class="btn btn-primary m-2" :disabled="!selectedB.length" @click="moveToA()"><b-icon-chevron-left></b-icon-chevron-left></button>
    </div>
    <div class="d-flex flex-column w-100">
      <label :for="idB">{{ selectedLabel }}</label>
      <b-select :id="idB" multiple :select-size="7" class="w-100" :options="optionsB" v-model="selectedB"></b-select>
    </div>
  </div>
</template>

<script>
import { v4 as uuid } from 'uuid';

export default {
  name: "TwoSidedMultiSelect",
  props: {
    value: {
      type: Array,
      default: () => []
    },
    options: {
      type: Array,
      default: () => []
    },
    notSelectedLabel: {
      type: String,
      default: 'Not Selected'
    },
    selectedLabel: {
      type: String,
      default: 'Selected'
    },
    id: {
      type: String,
      default: () => uuid()
    }
  },
  data: () => ({
    selectedA: [],
    selectedB: [],
  }),
  computed: {
    optionsValueSet() {
      return new Set(this.options.map(o => o?.value ?? o));
    },
    valueSet() {
      return new Set(this.value);
    },
    optionsA() {
      return this.options.filter(o => this.optionsValueSet.difference(this.valueSet).has(o?.value ?? o))
    },
    optionsB() {
      return this.options.filter(o => this.valueSet.has(o?.value ?? o));
    },
    idA() {
      return `${this.id}-select-a`
    },
    idB() {
      return `${this.id}-select-b`
    }
  },
  watch: {
    selectedA(newVal, oldVal) {
      if(!oldVal.length && newVal.length) {
        this.selectedB = []
      }
    },
    selectedB(newVal, oldVal) {
      if(!oldVal.length && newVal.length) {
        this.selectedA = []
      }
    },
  },
  methods: {
    emitAll(val) {
      this.$emit('input', val)
      this.$emit('change', val)
    },
    moveToA() {
      this.emitAll([...this.valueSet.difference(new Set(this.selectedB))]);
      this.selectedB = [];
    },

    moveToB() {
      this.emitAll([...this.valueSet.union(new Set(this.selectedA))]);
      this.selectedA = [];
    }
  }
}
</script>

<style>

</style>
