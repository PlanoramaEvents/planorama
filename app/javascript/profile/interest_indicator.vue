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
import { NEW_SESSION_ASSIGNMENT } from '../store/session_assignment.store';
import modelMixin from '../store/model.mixin';

export default {
  name: "InterestIndicator",
  mixins: [
    modelMixin
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
    ...mapActions({newMailingAction: NEW_SESSION_ASSIGNMENT}),
    new_assignment() {
      return {
        id: null,
        person_id: this.person_id,
        session_id: this.session.id,
        interested: true
      }
    },
    toggleSelectSession(arg) {
      // arg is the id of the selected item
      // console.debug('Toggle select this: ', this.interested)
      if (arg) {
        let new_assign = this.new_assignment()
        this.newMailingAction(new_assign).then(
          (obj) => {
            // problem, mutating a property
            this.assignment = obj
          }
        )
      } else {
        if (typeof this.assignment.id !== 'undefined') {
          this.delete(this.assignment).then(
            () => {
              // problem
              this.assignment = {}
            }
          )
        }
      }

    }
  },
  mounted() {
    // console.debug('MOUNT SELECTOR', this.value.id)
    this.assignment = this.session.my_assignment
    this.interested = typeof this.assignment.id !== 'undefined' //this.value.id == null
  }
}
</script>

<style>

</style>
