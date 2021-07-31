<template>  
  <b-select class="d-inline next-page" :value="value" @input="$emit('input', $event)" :options="nextPageOptions" @change="save"></b-select>
</template>

<script>
import { mapState } from 'vuex'
import pageMixin from './page-mixin'
export default {
  name: 'NextPagePicker',
  mixins: [pageMixin],
  props: ['value'],
  computed: {
    nextPageOptions() {
      console.log("selected page", this.selected_page.id)
      return [
        {value: null, text: 'Continue to next page'},
        ...this.survey.survey_pages.filter(p => p.id != this.selected_page.id).map((p, i) => ({
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
