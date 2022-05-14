<template>
  <v-select :options="areaNames" @input="$emit('input', $event)" :value="value" class="w-100"></v-select>
</template>

<script>
import { areaModel as model } from "@/store/area.store"
import { FETCH } from "@/store/model.store";

export default {
  name: "AreaSelectForSearch",
  props: ['value'],
  computed: {
    areaNames() {
      return Object.values(this.$store.getters['jv/get']({_jv: { type: model }})).map(a => a.name).sort((a, b)=> a < b ? -1 : 1 )
    }
  },
  mounted() {
    this.$store.dispatch(FETCH, {model});
  }
}

// for future reference, variable to change max height is --vs-dropdown-max-height;
</script>

<style>

</style>
