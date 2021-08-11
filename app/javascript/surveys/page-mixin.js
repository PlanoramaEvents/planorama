import surveyMixin from './survey.mixin';
import { mapState } from 'vuex'

const pageMixin = {
  mixins: [surveyMixin],
  computed: {
    ...mapState('surveys', ['selected_page']),
    selectedNumber() {
      return this.survey?.survey_pages?.indexOf(this.selected_page) + 1;
    },
    firstPage() {
      return this.selectedNumber == 1;
    },
    lastPage() {
      return this.selectedNumber == this.survey?.survey_pages?.length;
    },
    singlePage() {
      return this.survey.survey_pages.length < 2;
    }
  }, methods: {
    getPageIndex(id) {
      return this.survey.survey_pages.indexOf(this.getPageById(id));
    },
    getPageNumber(id) {
      return this.getPageIndex(id) + 1;
    },
    isSelectedPage(id) {
      return this.selected_page.id == id;
    },
    getPageById(id) {
      return this.survey.survey_pages.find(p => p.id == id);
    },
    isLastPage(id) {
      return this.getPageNumber(id) === this.survey.survey_pages.length;
    },
    getPageDescriptor(id) {
      let page = this.getPageById(id);
      return `${this.getPageNumber(id)} (${page.title})`;
    },
    getNextPage(id) {
      if(this.isLastPage(id)) {
        return null;
      }
      return this.survey.survey_pages[this.getPageIndex(id) + 1]
    }
  }
}

export default pageMixin;
