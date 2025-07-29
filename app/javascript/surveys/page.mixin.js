import surveyMixin from './survey.mixin';
import { pageModel as model, questionModel, NEW_PAGE } from '@/store/survey';
import { SELECT, SELECTED, DELETE, SAVE, PATCH_FIELDS, PATCH_RELATED, UNSELECT } from '@/store/model.store';
import { mapGetters, mapActions } from 'vuex';
import { toastMixin }  from '../mixins/toast-mixin';
import { PAGE_ADD_ERROR, PAGE_ADD_SUCCESS, PAGE_DELETE_ERROR, PAGE_DELETE_SUCCESS, PAGE_MERGE_ERROR, PAGE_MERGE_SUCCESS, PAGE_SAVE_ERROR, PAGE_SAVE_SUCCESS } from '@/constants/strings';
import { GET_CACHED_INDEX, GET_CACHED_PAGES, GET_CACHED_QUESTIONS, GET_CACHED_ANSWERS } from '../store/survey/survey.store';

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
      return this.getPageNumber(this.selectedPage?.id)
    },
    firstPage() {
      return this.selectedNumber === 1;
    },
    lastPage() {
      return this.selectedNumber === this.getNbrSurveyPages(this.survey);
    },
    singlePage() {
      return this.getNbrSurveyPages(this.survey) < 2;
    },
    selectedPageQuestions() {
      return this.selectedPage ? this.getPageQuestions(this.selectedPage) : [];
    }
  }, methods: {
    ...mapGetters({
      getCachedIndex: GET_CACHED_INDEX,
      getCachedPages: GET_CACHED_PAGES,
      getCachedQuestions: GET_CACHED_QUESTIONS,
      getCachedAnswers: GET_CACHED_ANSWERS
    }),
    ...mapActions({
      delete: DELETE,
      newPageAction: NEW_PAGE
    }),
    isSelectedPage(page) {
      return this.selectedPage && this.selectedPage.id === page.id
    },
    getPageIndex(id) {
      return this.getSurveyPages(this.survey).findIndex(p => p.id === id);
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
      return this.getPageNumber(id) === this.getNbrSurveyPages(this.survey);
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
      let cached = this.getCachedQuestions()(page.id)
      if (cached) {
        return cached
      } else {
        return Object.values(page?.questions ?? []).sort((a, b) => a.sort_order - b.sort_order)
      }
    },
    newPage(args) {
      return this.fetchSurveyToastPromise(this.newPageAction(args), PAGE_ADD_SUCCESS, PAGE_ADD_ERROR);
    },
    savePage(item) {
      if (!item && this.selectedPage) {
        item = this.selectedPage
      }

      // NOTE: this was needed because of changes to json vuex save!
      let fields = Object.keys(item._jv.attrs);
      return this.toastPromise(this.$store.dispatch(PATCH_FIELDS, {model, item: item, fields: fields}), PAGE_SAVE_SUCCESS, PAGE_SAVE_ERROR)
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
      return this.toastPromise(new Promise((res, rej) => {
        this.$store.dispatch(PATCH_RELATED, {item, parentRelName: 'questions', childIdName: 'page_id'}).then((data) => {
          // delete old page
          this.deletePage(oldPage).then(() => {
            // reload the survey
            this.fetchSelectedSurvey().then(() => res(data)).catch(rej)
          }).catch(rej)
        }).catch(rej)
      }), PAGE_MERGE_SUCCESS, PAGE_MERGE_ERROR)
    },
    deletePage(itemOrId) {
      return this.fetchSurveyToastPromise(this.delete({model, itemOrId}), PAGE_DELETE_SUCCESS, PAGE_DELETE_ERROR);
    },
    unselectPage() {
      this.$store.commit(UNSELECT, {model})
    }
  }
}

export default pageMixin;
