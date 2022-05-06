<template>
  <b-form ref='add-room-form'>
    <model-field label="Name" v-model="venueData.name" type="text" stateless></model-field>
    <model-field label="Address" v-model="venueData.address" type="text" stateless></model-field>
    <div class="d-flex justify-content-end" v-if='showButtons'>
      <b-button variant="link" @click="clear">Cancel</b-button>
      <b-button variant="primary" @click="saveVenue">Save</b-button>
    </div>
  </b-form>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import settingsMixin from "@/store/settings.mixin";
import { VENUES_ADD_VENUE_SUCCESS } from '@/constants/strings';
import ModelField from '../shared/model-field';

import { mapActions } from 'vuex';
import { NEW_VENUE } from '@/store/venue.store';

export default {
  name: "VenueEditor",
  components: {
    ModelField,
  },
  mixins: [
    toastMixin,
      settingsMixin
  ],
  props: {
    showButtons: {
      default: true,
      type: Boolean
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      venueData: {
        name: '',
        address: '',
      },
    }
  },
  emits: ["saved"],
  computed: {
    // venue_enums: {
    //   get: function() {
    //     if (this.currentSettings && this.currentSettings.enums) {
    //       return this.currentSettings.enums.Venue.target
    //     } else {
    //       return []
    //     }
    //   }
    // }
  },
  methods: {
    ...mapActions({newVenueAction: NEW_VENUE}),
    clear() {
      this.venueData.name = '';
      this.venueData.address = '';
    },
    setVenueData(data) {
      //console.log("setVenueData: ", data);
      if(data && data.name && data.address) {
        this.venueData.name = data.name;
        this.venueData.address = data.address;
      }
    },
    saveVenue() {
      let res = this.newVenueAction(this.venueData);
      res.then(
        (obj) => {
          this.$bvToast.toast(
            VENUES_ADD_VENUE_SUCCESS(obj.name),
            {
              variant: 'success',
              title: 'Venue Created'
            }
          )
          this.clear()
          this.$emit("saved");
        }
      ).catch(
        (err) => {
          this.$bvToast.toast(
            err.response.data.errors[0].title,
            {
              variant: 'danger',
              title: err.response.data.errors[0].title
            }
          )
        }
      );
    }
  }
}
</script>

<style>

</style>
