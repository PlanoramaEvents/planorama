<template>
</template>

<script>
import modelMixin from '../store/model.mixin'

export default {
  name: "SessionAssignment",
  props: ["assignment"],
  mixins: [
    modelMixin,
    // toastMixin
  ],
  watch: {
    "assignment.interest_notes" : function(val, oldVal) {
      // console.debug("assignment txt CHANGED", val, this.assignment.id)
      // this.$emit('change', this.assignment)
      this.saveAssignment()
    },
    "assignment.interest_ranking" : function(val, oldVal) {
      // console.debug("assignment ranking CHANGED", val, this.assignment.id)
      // this.$emit('change', this.assignment)
      this.saveAssignment()
    },
    "assignment.interest_role" : function(val, oldVal) {
      // console.debug("assignment role CHANGED", val, this.assignment.id)
      // this.$emit('change', this.assignment)
      this.saveAssignment()
    }
  },
  methods: {
    saveAssignment() {
      this.save(this.assignment).then(
        (data) => {
          // TODO: this mutation is a problem, so how do we update the person
          // this.person = data
          this.$emit('change', data)
        }
      )
    }
  }
}
</script>
