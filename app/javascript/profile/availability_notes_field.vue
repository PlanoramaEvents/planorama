<template>
  <b-form-group
    class="mt-4"
    :label="AVAILABILITY_NOTES_LABEL"
    label-for="availability-notes-input"
    v-if="editable_person"
  >
    <b-form-textarea
      id="availability-notes-input"
      v-model="editable_person.availability_notes"
      @blur="patchCurrentUserAvailabilityNotes()"
    ></b-form-textarea>
  </b-form-group>
</template>

<script>
import { modelMixin, toastMixin } from "@/mixins";
import { personModel as model } from "@/store/person.store";
import {
  SAVE_AVAILABILITY_NOTES,
  AVAILABILITY_NOTES_LABEL
} from '@/constants/strings'

export default {
  name: "AvailabilityNotesField",
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    }
  },
  mixins: [
    modelMixin,
    toastMixin
  ],
  data: () => ({
    AVAILABILITY_NOTES_LABEL,
    editable_person: null
  }),
  methods: {
    patchCurrentUserAvailabilityNotes() {
      this.save(this.editable_person).then(
        (obj) => {
          this.editable_person = obj
          this.$emit('input',this.editable_person)
        }
      )
    }
  },
  mounted() {
    this.editable_person = this.person
  }
}
</script>

<style>

</style>
