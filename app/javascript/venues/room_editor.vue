<template>
  <div>
    <b-button variant="link" @click="back">Back</b-button>
    <div v-if="selected">
      <b-form-group id="name-group" label="Name" label-for="name-input">
        <b-form-input type="text" id="name-input" v-model="selected.name" @blur="saveSelected()"></b-form-input>
      </b-form-group>
      <b-form-group
        label="Venue"
      >
        <model-select
          id="room-venue"
          v-model="selected.venue_id"
          model="venue"
          field="name"
          :multiple="false"
          @change="saveSelected()"
          :selectSize="4"
        ></model-select>
      </b-form-group>
      <b-form-group id="floor-group" label="Floor" label-for="floor-input">
        <b-form-input type="number" id="floor-input" v-model="selected.floor" @blur="saveSelected()"></b-form-input>
      </b-form-group>
      <b-form-group>
        <b-form-checkbox switch v-model="selected.is_virtual" @change="saveSelected">
          Is Online
        </b-form-checkbox>
      </b-form-group>
      <b-form-group id="capacity-group" label="Capacity" label-for="capacity-input">
        <b-form-input type="number" id="capacity-input" v-model="selected.capacity" @blur="saveSelected()"></b-form-input>
      </b-form-group>
      <b-form-group>
        <b-form-checkbox switch v-model="selected.open_for_schedule" @change="saveSelected">
          Open for Scheduling
        </b-form-checkbox>
      </b-form-group>
      <b-form-group id="purpose-group" label="Purpose" label-for="purpose-input">
        <b-form-textarea id="purpose-input" v-model="selected.purpose" @blur="saveSelected()"></b-form-textarea>
      </b-form-group>
      <b-form-group id="purpose-group" label="Comment" label-for="purpose-input">
        <b-form-textarea id="purpose-input" v-model="selected.comment" @blur="saveSelected()"></b-form-textarea>
      </b-form-group>
    </div>
  </div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins';
import ModelField from '@/components/model-field';
import ModelSelect from '@/components/model_select';

export default {
  name: "RoomEditor",
  props: [
    'id'
  ],
  mixins: [modelMixinNoProp],
  components: { ModelField, ModelSelect },
  data: () => ({ model: "room" }),
  methods: {
    back() {
      this.$router.push('/venues/rooms')
    },
  },
  mounted() {
    this.select(this.id)
    this.fetchSelected()
  },
}
</script>

<style></style>
