<template>
  <div class="scrollable">
    {{room}}
    <b-button variant="link" @click="back">Back</b-button>
    <!-- TODO: wrap in permission  -->
    <label>Room Name</label>
    <b-form-input type="text" v-model="room.name" @blur="saveRoom()"></b-form-input>
    <label>Purpose</label>
    <b-form-input type="text" v-model="room.purpose" @blur="saveRoom()"></b-form-input>
    <label>Comment</label>
    <b-form-input type="text" v-model="room['comment']" @blur="saveRoom()"></b-form-input>
    <label>Capacity</label>
    <b-form-input type="text" v-model="room.capacity" @blur="saveRoom()"></b-form-input>
    <label>Floor</label>
    <b-form-input type="text" v-model="room['floor']" @blur="saveRoom()"></b-form-input>
    <label>Sort Order</label>
    <b-form-input type="text" v-model="room['sort_order']" @blur="saveRoom()"></b-form-input>
    <label>Open for Schedule</label>
    <b-form-input type="text" v-model="room['open_for_schedule']" @blur="saveRoom()"></b-form-input>
    <label>Virtual?</label>
    <b-form-input type="text" v-model="room['is_virtual']" @blur="saveRoom()"></b-form-input>
    <label>Area</label>
    <b-form-input type="text" v-model="room.area" @blur="saveRoom()"></b-form-input>
    <label>Length</label>
    <b-form-input type="text" v-model="room.length" @blur="saveRoom()"></b-form-input>
    <label>Width</label>
    <b-form-input type="text" v-model="room.width" @blur="saveRoom()"></b-form-input>
    <label>Height</label>
    <b-form-input type="text" v-model="room.height" @blur="saveRoom()"></b-form-input>
  </div>
</template>

<script>
import {DELETE, FETCH_SELECTED, SAVE, SELECT, SELECTED, UNSELECT} from "@/store/model.store";
import {roomModel as model} from "@/store/room.store";
import toastMixin from '../shared/toast-mixin';
import {mapGetters, mapState, mapActions} from 'vuex';
import {
  VENUES_DELETE_ROOM_ERROR,
  VENUES_DELETE_ROOM_SUCCESS, VENUES_SAVE_ROOM_ERROR, VENUES_SAVE_ROOM_SUCCESS
} from "@/constants/strings";
import ModelField from '../shared/model-field';

export default {
  name: "EditRoom",
  props: ['id'],
  mixins: [
      toastMixin
  ],
  components: {
    ModelField
  },
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    room() {
      return this.selected({model});
    },
  },
  methods: {
    init() {
      this.selectRoom(this.id)
    },
    back() {
      this.unselectRoom();
      this.$router.push('/venues');
    },
    saveRoom(newRoom, success_text = VENUES_SAVE_ROOM_SUCCESS, error_text = VENUES_SAVE_ROOM_ERROR()) {
      if (!newRoom) {
        newRoom = this.room;
      }
      return this.toastPromise(this.$store.dispatch(SAVE, {model, selected: true, item: newRoom}), success_text, error_text)
    },
    selectRoom(itemOrId) {
      this.$store.commit(SELECT, {model, itemOrId});
    },
    unselectRoom() {
      this.$store.commit(UNSELECT, {model})
    },
    fetchSelectedRoom() {
      console.debug("FETCHING SELCTED ROOM")
      return this.$store.dispatch(FETCH_SELECTED, {model});
    },
    deleteRoom(itemOrId, success_text = VENUES_DELETE_ROOM_SUCCESS, error_text = VENUES_DELETE_ROOM_ERROR()) {
      if (!itemOrId) {
        itemOrId = this.survey;
      }
      return this.toastPromise(this.$store.dispatch(DELETE, {model, itemOrId}), success_text, error_text);
    },
  },
  mounted() {
    this.init()
  }
}
</script>

<style lang="scss" scoped>
.survey {
  .form-group {
    max-width: 60rem;
  }
}
</style>
