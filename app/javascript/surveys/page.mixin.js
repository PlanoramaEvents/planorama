import surveyMixin from './survey.mixin';
import { pageModel as model } from '../store/survey.store';
import { SELECT, SELECTED } from '../store/model.store';
import { mapGetters } from 'vuex';

// CONVERTED
const pageMixin = {
  mixins: [surveyMixin],
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    selectedPage() {
      return this.selected({model});
    },
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
      return this.selectedPage ? this.getPageQuestions(this.selectedPage) : [];
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
    },
    getPageQuestions(page) {
      let questions = page.survey_questions;
      if (!questions) return [];
      let order = page._jv.relationships.survey_questions.data.map(q => q.id);
      // these are going to be in order
      return Object.values(questions).sort((a, b) => order.indexOf(a.id) - order.indexOf(b.id))
    }
  }
}

export default pageMixin;
