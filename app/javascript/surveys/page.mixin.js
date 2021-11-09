import surveyMixin from './survey.mixin';
import { pageModel as model, questionModel, NEW_PAGE } from '../store/survey.store';
import { SELECT, SELECTED, DELETE, SAVE, PATCH_RELATED } from '../store/model.store';
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
      return this.survey._jv.relationships.pages.data.length < 2;
    },
    selectedPageQuestions() {
      return this.selectedPage ? this.getPageQuestions(this.selectedPage) : [];
    }
  }, methods: {
    ...mapActions({
      delete: DELETE,
      newPage: NEW_PAGE
    }),
    isSelectedPage(page) {
      return this.selectedPage && this.selectedPage.id === page.id
    },
    getPageIndex(id) {
      return this.survey._jv.relationships.pages.data.findIndex(p => p.id === id);
    },
    getPageNumber(id) {
      return this.getPageIndex(id) + 1;
    },
    isSelectedPage(page) {
      return this.page && this.selectedPage && this.selectedPage.id === page.id;
    },
    getPageById(id) {
      return this.survey.pages[id];
    },
    isFirstPage(id) {
      return this.getPageNumber(id) === 1;
    },
    isLastPage(id) {
      return this.getPageNumber(id) === this.survey._jv.relationships.pages.data.length;
    },
    getPageDescriptor(id) {
      let page = this.getPageById(id);
      return `${this.getPageNumber(id)} (${page.title})`;
    },
    getPreviousPage(id) {
      if (this.isFirstPage(id)) {
        return null;
      }

      return this.getSurveyPages(this.survey)[this.getPageIndex(id) - 1];
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
      return getOrderedRelationships('questions', page)
    },
    savePage(item) {
      if (!item && this.selectedPage) {
        item = this.selectedPage
      }
      return new Promise((res, rej) => {
        this.toastPromise(this.$store.dispatch(SAVE, {model, item}), "IT WORKED").then((data) => {
          this.fetchSelectedSurvey().then(() => {
            res(data);
          }).catch(rej);
        }).catch(rej);
      })
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
        this.$store.dispatch(PATCH_RELATED, {item, parentRelName: 'questions', childIdName: 'page_id'}).then((data) => {
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
