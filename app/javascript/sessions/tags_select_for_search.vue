<template>
  <v-select :options="tagNames" @input="$emit('input', $event)" :value="value" class="w-100"></v-select>
</template>

<script>
import { curatedTagModel as model } from "@/store/curated_tag.store"
import { FETCH } from "@/store/model.store";

export default {
  name: "TagsSelectForSearch",
  props: ['value'],
  computed: {
    tagNames() {
      return Object.values(this.$store.getters['jv/get']({ _jv: { type: model }}, '$[?(@.context=="tag")]')).map(a => a.name).sort((a, b) => a < b ? -1 : 1)
    }
  },
  
  mounted() {
    this.$store.dispatch(FETCH, { model });
  }
}
</script>

<style></style>
