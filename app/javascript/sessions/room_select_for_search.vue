<template>
  <v-select :options="roomNames" @input="$emit('input', $event)" :value="value" class="w-100"></v-select>
</template>

<script>
import { roomModel as model } from "@/store/room.store"
import { FETCH } from "@/store/model.store";

export default {
  name: "RoomSelectForSearch",
  props: ['value'],
  computed: {
    roomNames() {
      return Object.values(this.$store.getters['jv/get']({_jv: { type: model }})).map(a => a.name).sort((a, b)=> a < b ? -1 : 1 )
    }
  },
  mounted() {
    this.$store.dispatch(FETCH, {model});
  }
}
</script>
