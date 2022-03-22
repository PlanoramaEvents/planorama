<template>
  <b-select
    :id="id"
    class="d-inline next-page"
    :value="value"
    @input="$emit('input', $event)"
    :options="nextPageOptions"
    @change="$emit('change', $event)"
    ></b-select>
</template>

<script>
import { pageMixin, surveyMixin } from '@mixins'
export default {
  name: 'NextPagePicker',
  mixins: [pageMixin, surveyMixin],
  props: {
    value: {},
    forPage: {
      type: String
    },
    id: {
      type: String,
      default: 'page-picker',
    }
  },
  computed: {
    pageId() {
      return this.forPage || this.selectedPage?.id;
    },
    nextPageOptions() {
      return [
        {value: null, text: 'Continue to next page'},
        ...this.selectedSurveyPages.filter(p => p.id != this.pageId).map((p, i) => ({
          value: p.id, text: `Go to page ${this.getPageDescriptor(p.id)}`
        })),
        {value: -1, text: 'Submit survey'}
      ]
    }
  },
}
</script>

<style>

</style>
