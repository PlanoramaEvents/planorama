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
    "assignment.interest_ranking" : function(val, oldVal) {
      this.changeAssignment()
    },
    "assignment.interest_role" : function(val, oldVal) {
      this.changeAssignment()
    }
  },
  methods: {
    changeAssignment() {
      this.$emit('change', this.assignment)
    }
  }
}
</script>
