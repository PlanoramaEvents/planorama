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
        Confirm that you are no longer interested in that session.
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
    person_id: null
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
      this.removeInterest(this.assignment).then(
        (res) => {
          this.assignment = res
        }
      )
    },
    toggleSelectSession(arg) {
      if (arg) {
        this.expressInterest(this.session).then(
          (obj) => {
            this.assignment = obj
          }
        )
      } else {
        this.$refs['unexpress-interest-modal'].show()
      }
    }
  },
  mounted() {
    this.assignment = this.session.my_interest
    this.interested = (typeof this.assignment.id !== 'undefined') && this.assignment.interested
  }
}
</script>

<style>

</style>
