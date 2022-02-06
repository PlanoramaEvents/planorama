<template>
</template>

<script>
import modelMixin from '../store/model.mixin'

export default {
  name: "SessionAssignment",
  props: ["assignment"],
  mixins: [
    modelMixin,
  ],
  watch: {
    "assignment.interest_notes" : function(val, oldVal) {
      this.saveAssignment()
    },
    "assignment.interest_ranking" : function(val, oldVal) {
      this.saveAssignment()
    },
    "assignment.interest_role" : function(val, oldVal) {
      this.saveAssignment()
    }
  },
  methods: {
    saveAssignment() {
      this.save(this.assignment).then(
        (data) => {
          this.$emit('change', data)
        }
      )
    }
  }
}
</script>
