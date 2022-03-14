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
    enabled: false,
    // linkedFields
  }),
  methods: {
    unlinkIfLinked() {
      // If the box is unchecked ensure that the question is not linked
      // console.debug("**** UNLINK ????", this.enabled, this.question)
      if (!this.enabled) {
        this.question.linked_field = null
      }
    },
    linkField() {
      console.debug('**** LINK THE FIELD')

    }
  },
  computed: {
    canLink() {
      console.debug('**** SEE IF WE CAN LINK', this.question.question_type)
      // return !!linkedFields[this.question?.question_type]
      let linkabled = this.canLinkField(this.question.question_type)
      console.debug("AND ", linkabled)
      return linkabled
    },
    fieldOptions() {
      return this.linkedFieldsFor(this.question.question_type)
    }
  }
}
</script>

<style>

</style>
