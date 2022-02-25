<template>
  <div>
    <b-form-checkbox v-model="enabled" :disabled="!canLink" @change="unlinkIfLinked">Linked</b-form-checkbox>
    <b-form-select :disabled="!enabled" v-model="question.linked_field" @change="linkField" :select-size="4">
      <b-form-select-option value="" :disabled="!!question.linked">Select field</b-form-select-option>
      <b-form-select-option-group v-for="group in linkedCategories" :key="group.value" :label="group.text">
        <b-form-select-option v-for="{value, text} in linkedFields[group.value]" :key="value" :value="value" :disabled="isLinkedFieldDisabled(question.question_type, value)">
          {{text}}
        </b-form-select-option>
      </b-form-select-option-group>
    </b-form-select>
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
    linkedFields
  }),
  computed: {
    canLink() {
      return !!linkedFields[this.question?.question_type]
    },
    linkedCategories() {
      return this.questionTypes.filter(t => linkedFields[t.value])
    }
  },
  watch: {
    question(newVal, oldVal) {
      this.captureLinkedValue(newVal?.linked_field);
      if(newVal?.id !== oldVal?.id)
        this.enabled = !!(newVal?.linked_field)
    }
  }
}
</script>

<style>

</style>
