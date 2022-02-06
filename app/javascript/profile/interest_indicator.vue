<template>
  <b-form-checkbox
    switch size="lg"
    v-model="interested"
    @change="toggleSelectSession"
  >
  </b-form-checkbox>
</template>

<script>
import { mapActions } from 'vuex';
import sessionAssignmentMixin from '../sessions/session_assignment.mixin';

export default {
  name: "InterestIndicator",
  mixins: [
    sessionAssignmentMixin
  ],
  props: {
    session: { // TODO: this gets changed by the edit, which is a problem???
      type: Object,
      default: null
    },
    person_id: null
  },
  data: () => ({
    interested: false,
    assignment: null
  }),
  methods: {
    toggleSelectSession(arg) {
      // arg is the id of the selected item
      if (arg) {
        this.expressInterest(this.session).then(
          (obj) => {
            this.assignment = obj
          }
        )
      } else {
        this.removeInterest(this.assignment).then(
          () => {
            this.assignment = null
          }
        )
      }
    }
  },
  mounted() {
    this.assignment = this.session.my_interest
    this.interested = typeof this.assignment.id !== 'undefined'
  }
}
</script>

<style>

</style>
