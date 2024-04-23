<template>
  <b-form-group label="Pokój" class="ml-2" label-cols="12" label-cols-md="1">
    <div class="form-row">
      <b-form-select size="sm" class="col-6" :value="value" @input="$emit('input', $event)" :options="roomOptions" @change="$emit('change', $event)">
      </b-form-select>
    </div>
  </b-form-group>
</template>

<script>
import { modelMixinNoProp } from "@/mixins";

export default {
  name: "RoomPicker",
  props: ['value'],
  mixins: [
    modelMixinNoProp
  ],
  data: () => ({
    model: 'room'
  }),
  computed: {
    roomOptions() {
      return [{text: "Brak wybranego pokoju", value: null}, ...this.collection.sort((a,b) => b.sortorder - a.sortorder).map(r => ({text: r.name, value: r.id}))]
    }
  },
  mounted() {
    this.fetch();
  }
}
</script>

<style>

</style>
