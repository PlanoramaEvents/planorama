import surveyMixin from './survey.mixin';
import { pageModel as model, questionModel } from '../store/survey.store';
import { SELECT, SELECTED, DELETE, SAVE } from '../store/model.store';
import { mapGetters, mapActions } from 'vuex';
import { getOrderedRelationships } from '../utils/jsonapi_utils';
import { toastMixin }  from '../toast-mixin';

// CONVERTED
export const pageMixin = {
  mixins: [surveyMixin, toastMixin],
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
    ...mapActions({
      delete: DELETE
    }),
    isSelectedPage(page) {
      return this.selectedPage && this.selectedPage.id === page.id
    },
    getPageIndex(id) {
      return this.survey._jv.relationships.survey_pages.data.findIndex(p => p.id === id);
    },
    getPageNumber(id) {
      return this.getPageIndex(id) + 1;
    },
    isSelectedPage(page) {
      return this.page && this.selectedPage && this.selectedPage.id === page.id;
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
    },
    savePage(item) {
      if (!item && this.selectedPage) {
        item = this.selectedPage
      }
      return this.toastPromise(this.$store.dispatch(SAVE, {model, item}), "IT WORKED")
    },
    mergePage(oldPage, newPage) {
      // move questions to new page
      let questions = this.getPageQuestions(oldPage)
      // save new page as question owner
      let item = {
        _jv: {
          id: newPage.id,
          type: model,
          relationships: {
            questions: {
              data: questions.map(q => ({id: q.id, type: questionModel}))
            }
          }
        }
      }
      return new Promise((res, rej) => {
        this.$store.dispatch('jv/postRelated', item).then((data) => {
          // delete old page
          this.deletePage(oldPage).then(() => {
            res(data)
          }).catch(rej)
        }).catch(rej)
      })
    },
    deletePage(itemOrId) {
      return this.delete({ model, itemOrId })
    }
  }
}

export default pageMixin;
