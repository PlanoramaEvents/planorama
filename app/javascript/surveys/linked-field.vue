<template>
  <div>
    <b-form-checkbox v-model="enabled" :disabled="!canLink" @change="unlinkIfLinked">Linked</b-form-checkbox>
    <b-form-select
      :disabled="!enabled"
      v-model="question.linked_field"
      @change="linkField"
      :select-size="4"
      :options="fieldOptions"
    >
    </b-form-select>
  </div>
</template>

<script>
import { linkedMixin } from '@/mixins';

export default {
  name: "LinkedField",
  mixins: [linkedMixin],
  props: {
    question: {
      type: Object,
      required: true
    }
  },
  data: () => ({
    enabled: false
  }),
  methods: {
    unlinkIfLinked() {
      // If the box is unchecked ensure that the question is not linked
      if (!this.enabled) {
        this.question.linked_field = null
        this.$emit('change', this.question.linked_field)
      }
    },
    linkField(arg) {
      this.$emit('change', arg)
    }
  },
  computed: {
    canLink() {
      return this.canLinkField(this.question.question_type)
    },
    fieldOptions() {
      return this.linkedFieldsFor(this.question.question_type)
    }
  },
  mounted() {
    this.enabled = this.question.linked_field != null
  }
}
</script>

<style>

</style>
