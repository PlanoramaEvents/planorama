<template>
  <v-select :options="tagNames" @input="$emit('input', $event)" :value="value" class="w-100"></v-select>
</template>

<script>
// import { areaModel as model } from "@/store/area.store"
// import { FETCH } from "@/store/model.store";

export default {
  name: "TagsSelectForSearch",
  props: ['value'],
  computed: {
    tagNames() {
      // return Object.values(this.$store.getters['jv/get']({ _jv: { type: model } })).map(a => a.name).sort((a, b) => a < b ? -1 : 1)
      return ['cabbages', 'kings', 'queens', 'rutabegas', 'radishes'];
    }
  },
  mounted() {
    // this.$store.dispatch(FETCH, { model });
  }
}
</script>

<style></style>
