<template>
  <div>
    <b-button variant="link" @click="back">Back</b-button>
    <div v-if="selected">{{ selected.id }}</div>
    <b-form-group id="name-group" label="Name" label-for="name-input">
      <b-form-input type="text" id="name-input" v-model="selected.name" @blur="saveSelected()"></b-form-input>
    </b-form-group>
    <b-form-group id="purpose-group" label="Description" label-for="purpose-input">
      <b-form-textarea id="purpose-input" v-model="selected.purpose" @blur="saveSelected()"></b-form-textarea>
    </b-form-group>
    <b-form-group id="area-group" label="Area" label-for="area-input">
      <b-form-input type="number" id="area-input" v-model="selected.area_of_space" @blur="saveSelected()"></b-form-input>
      sq ft
    </b-form-group>
    <b-form-group id="height-group" label="Ceiling Height" label-for="height-input">
      <b-form-input type="number" id="height-input" v-model="selected.height" @blur="saveSelected()"></b-form-input>
      ft
    </b-form-group>
    <b-form-group id="length-group" label="Length" label-for="length-input">
      <b-form-input type="number" id="length-input" v-model="selected.length" @blur="saveSelected()"></b-form-input>
      ft
    </b-form-group>
    <b-form-group id="width-group" label="Width" label-for="width-input">
      <b-form-input type="number" id="width-input" v-model="selected.width" @blur="saveSelected()"></b-form-input>
      ft
    </b-form-group>
    <b-form-group id="capacity-group" label="Capacity" label-for="capacity-input">
      <b-form-input type="number" id="capacity-input" v-model="selected.capacity" @blur="saveSelected()"></b-form-input>
    </b-form-group><b-form-group id="floor-group" label="Floor" label-for="floor-input">
      <b-form-input type="number" id="floor-input" v-model="selected.floor" @blur="saveSelected()"></b-form-input>
    </b-form-group>
    <!-- <model-field label="Name" v-model="selected.name" type="text" stateless></model-field> -->
    <!-- <b-form ref='add-room-form'>
    <model-field label="Floor" v-model="roomData.floor" type="text" stateless></model-field>
    <model-field label="Purpose" v-model="roomData.purpose" type="text" stateless></model-field>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="saveRoom">Save</b-button>
    </div>
  </b-form> -->
  </div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins';
import { SELECTED } from '@/store/model.store';
import ModelField from '../shared/model-field';

export default {
  name: "RoomEditor",
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
    this.fetchSelected()
  },
}
</script>

<style></style>
