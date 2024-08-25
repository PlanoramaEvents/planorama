<template>
  <div>
    <b-button variant="link" @click="back">Back</b-button>
    <div v-if="selected">{{ selected.id }}</div>
    <b-form-group id="name-group" label="Name" label-for="name-input">
      <b-form-input type="text" id="name-input" v-model="selected.name" @blur="saveSelected()"></b-form-input>
    </b-form-group>
    <b-form-group id="address-group" label="Address" label-for="address-input">
      <b-form-textarea id="address-input" v-model="selected.address" @blur="saveSelected()"></b-form-textarea>
    </b-form-group>
  </div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins';
import { SELECTED } from '@/store/model.store';
import ModelField from '../shared/model-field';

export default {
  name: "VenueEditor",
  props: [
    'id'
  ],
  mixins: [modelMixinNoProp],
  components: { ModelField },
  data: () => ({ model: "room" }),
  methods: {
    back() {
      this.$router.push('/venues')
    },
  },
  mounted() {
    this.select(this.id)
    this.fetch_selected()
  },
}
</script>

<style>

</style>
