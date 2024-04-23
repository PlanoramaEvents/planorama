<template>
  <div>
    <b-form-checkbox
      switch size="lg"
      v-model="interested"
      @change="toggleSelectSession"
    >
    </b-form-checkbox>

    <b-modal
      title="Confirm Not Interested"
      ref="unexpress-interest-modal"
      @hidden="stillInterested"
      @ok="okNotInterested"
    >
      <p class="my-4">
        Potwierdź, że nie jesteś już zainteresowany tą sesją.
      </p>
    </b-modal>
  </div>
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
    person_id: null,
    assignments: null
  },
  data: () => ({
    interested: false,
    assignment: null
  }),
  methods: {
    stillInterested() {
      this.interested = this.assignment && this.assignment.interested
    },
    okNotInterested() {
      this.removeInterest(this.assignment, this.person_id).then(
        (res) => {
          this.assignment = res
          this.interested = this.assignment.interested
        }
      )
    },
    toggleSelectSession(arg) {
      if (arg) {
        this.expressInterest(this.session, this.person_id).then(
          (obj) => {
            this.assignment = obj
          }
        ).catch(
          () => {
            this.interested = false
          }
        )
      } else {
        if (this.assignment.interest_ranking || this.assignment.interest_notes || this.assignment.interest_role) {
          this.$refs['unexpress-interest-modal'].show()
        } else {
          this.okNotInterested()
        }
      }
    }
  },
  mounted() {
    if (this.session) {
      this.assignment = this.assignments.find(a => a.session_id == this.session.id)
      if (this.assignment) {
        this.interested = this.assignment.interested
      }
    }
  }
}
</script>

<style>

</style>
