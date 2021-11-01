import surveyMixin from './survey.mixin';
import { pageModel as model } from '../store/survey.store';
import { SELECT, SELECTED } from '../store/model.store';
import { mapGetters } from 'vuex';
import { getOrderedRelationships } from '../utils/jsonapi_utils';

// CONVERTED
export const pageMixin = {
  mixins: [surveyMixin],
  computed: {
    ...mapGetters({
      selected: SELECTED
    }),
    selectedPage() {
      return this.selected({model});
    },
    selectedNumber() {
      return this.getPageNumber(this.selectedPage.id)
    },
    firstPage() {
      return this.selectedNumber === 1;
    },
    lastPage() {
      return this.selectedNumber === this.survey._jv.relationships.survey_pags.data.length;
    },
    singlePage() {
      return this.survey._jv.relationships.survey_pages.data.length < 2;
    },
    selectedPageQuestions() {
      return this.selectedPage ? this.getPageQuestions(this.selectedPage) : [];
    }
  }, methods: {
    getPageIndex(id) {
      return this.survey._jv.relationships.survey_pages.data.findIndex(p => p.id === id);
    },
    getPageNumber(id) {
      return this.getPageIndex(id) + 1;
    },
    isSelectedPage(id) {
      return this.selectedPage.id === id;
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
      
      return this.getSurveyPages(this.survey)[this.getPageIndex(id) + 1]
    },
    selectPage(itemOrId) {
      this.$store.commit(SELECT, {model, itemOrId});
    },
    getPageQuestions(page) {
      return getOrderedRelationships('survey_questions', page)
    }
  }
}

export default pageMixin;
