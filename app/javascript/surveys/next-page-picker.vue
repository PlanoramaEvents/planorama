<template>  
  <b-select :id="id" class="d-inline next-page" :value="value" @input="$emit('input', $event)" :options="nextPageOptions" @change="save"></b-select>
</template>

<script>
import { mapState } from 'vuex'
import pageMixin from './page-mixin'
export default {
  name: 'NextPagePicker',
  mixins: [pageMixin],
  props: {
    value: {},
    forPage: {
      type: Number
    },
    id: {
      type: String,
      default: 'page-picker',
    }
  },
  computed: {
    pageId() {
      return this.forPage || this.selected_page.id;
    },
    nextPageOptions() {
      return [
        {value: null, text: 'Continue to next page'},
        ...this.survey.survey_pages.filter(p => p.id != this.pageId).map((p, i) => ({
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
