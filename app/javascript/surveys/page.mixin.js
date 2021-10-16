import surveyMixin from './survey.mixin';
import { mapState } from 'vuex'
import { pageModel as model } from '../store/survey.store';
import { SELECT } from '../store/model.store';

// CONVERTED
const pageMixin = {
  mixins: [surveyMixin],
  computed: {
    ...mapState(['selectedPage']),
    selectedNumber() {
      // TODO are we using sort_order as an index? or should we process them into an array? or have some meta data??
      return this.survey?.survey_pages?.[this.$store.selected[model]].sort_order + 1
    },
    firstPage() {
      return this.selectedNumber == 1;
    },
    lastPage() {
      return this.selectedNumber == this.survey?._jv?.relationships?.survey_pags?.data?.length;
    },
    singlePage() {
      return this.survey?._jv?.relationships?.survey_pages?.data?.length < 2;
    },
    selectedPageQuestions() {
      let questions = this.selectedPage?.survey_questions;
      if (!questions) return [];
      // these are going to be in order
      return Object.values(questions).sort((a, b) => a.sort_order - b.sort_order)

    }
  }, methods: {
    getPageIndex(id) {
      return this.survey.survey_pages[id].sort_order;
    },
    getPageNumber(id) {
      return this.getPageIndex(id) + 1;
    },
    isSelectedPage(id) {
      return this.$store.selected.page == id;
    },
    getPageById(id) {
      return this.survey.survey_pages[id];
    },
    isLastPage(id) {
      return this.getPageNumber(id) === this.survey._jv.relationships.survey_pages.data.length;
    },
    getPageDescriptor(id) {
      let page = this.getPageById(id);
      return `${this.getPageNumber(id)} (${page.title})`;
    },
    getNextPage(id) {
      if(this.isLastPage(id)) {
        return null;
      }
      const targetSortOrder = this.getPageIndex(id);
      return Object.values(this.survey.survey_pages).find(p => p.sort_order == targetSortOrder)
    },
    selectPage(itemOrId) {
      this.$store.commit(SELECT, {model, itemOrId});
    }
  }
}

export default pageMixin;
