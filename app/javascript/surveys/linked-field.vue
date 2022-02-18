<template>
  <div>
    <b-form-checkbox v-model="enabled" :disabled="!canLink" @change="unlinkIfLinked">Linked</b-form-checkbox>
    <b-form-select :disabled="!enabled" v-model="question.linked" :options="dropdownOptions" @change="linkField"> </b-form-select>
  </div>
</template>

<script>
import { linkedMixin } from '@/mixins';
import {linkedFields} from './linked-fields.js'

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
  }),
  computed: {
    canLink() {
      return !!this.dropdownOptions.find(o => o.value === this.question?.question_type)
    },
    dropdownOptions() {
      return linkedFields(this.question?.question_type, this.question?.linked)
    }
  },
  watch: {
    question(newVal, oldVal) {
      this.captureLinkedValue(newVal?.linked);
      if(newVal?.id !== oldVal?.id)
        this.enabled = !!(newVal?.linked)
    }
  }
}
</script>

<style>

</style>
