<template>
  <v-select :options="formatNames" @input="$emit('input', $event)" :value="value" class="w-100"></v-select>
</template>

<script>
import { formatModel as model } from "@/store/format.store"
import { FETCH } from "@/store/model.store";

export default {
  name: "FormatSelectForSearch",
  props: ['value'],
  computed: {
    formatNames() {
      let vals = this.$store.getters['jv/get']({_jv: { type: model }})
      return Object.values(vals).map(a => a.name).sort((a, b)=> a < b ? -1 : 1 )
    }
  },
  mounted() {
    this.$store.dispatch(FETCH, {model});
  }
}
</script>
