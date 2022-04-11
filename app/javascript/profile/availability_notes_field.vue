<template>
  <b-form-group
    class="mt-4"
    :label="AVAILABILITY_NOTES_LABEL"
    label-for="availability-notes-input"
  > 
    <b-form-textarea id="availability-notes-input" v-model="mutableCurrentUser.availability_notes" @blur="patchCurrentUserAvailabilityNotes()"></b-form-textarea>
  </b-form-group>
    
</template>

<script>
import { personSessionMixin, toastMixin } from "@/mixins";
import { mapActions } from 'vuex';
import { PATCH_FIELDS } from '@/store/model.store';
import { personModel as model } from "@/store/person.store";
import { utils } from 'jsonapi-vuex';
import {
  SAVE_AVAILABILITY_NOTES,
  AVAILABILITY_NOTES_LABEL
} from '@/constants/strings'

export default {
  name: "AvailabilityNotesField",
  mixins: [
    personSessionMixin,
    toastMixin
  ],
  data: () => ({
    AVAILABILITY_NOTES_LABEL
  }),
  computed: {
    mutableCurrentUser() {
      return utils.deepCopy(this.currentUser);
    }
  },
  methods: {
    ...mapActions({
      patchFields: PATCH_FIELDS
    }),
    patchCurrentUserAvailabilityNotes() {
      return this.toastPromise(this.patchFields({model, item: this.mutableCurrentUser, fields: ['availability_notes'], selected: false }), SAVE_AVAILABILITY_NOTES)
    }
  }
}
</script>

<style>

</style>
