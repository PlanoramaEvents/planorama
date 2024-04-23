<template>
  <div class="page m-3">
    <div class="page-label">
      <span :class="[singlePage ? 'd-none' : 'd-inline-block']">Strona {{i + 1}} z {{n}} </span>
    </div>
    <div :class="['page-title', 'p-3', 'border', {selected: isSelected}]" @click="onPageClick">
      <b-form-group
        v-if="isSelected"
        :label="i === 0 ? 'Tytuł Wyświetlany' : 'Tytuł Strony'"
        :label-for="'page-title-' + page.id"
      >
        <b-form-input :id="'page-title-' + page.id" type="text" v-model="page.title" @change="savePage(page)"></b-form-input>
      </b-form-group>
      <div class="row" v-if="isSelected && i !== 0">
        <div class="col-12 d-flex justify-content-end">
          <b-button variant="info" title="Scal stronę w górę" class="mr-2" @click="mergePageUp"><b-icon-arrow-up-circle-fill></b-icon-arrow-up-circle-fill></b-button>
          <b-button variant="info" title="Usuń stronę" v-b-modal="deleteModalId"><b-icon-trash></b-icon-trash></b-button>
        </div>
      </div>
      <h3 v-if="!isSelected">{{page.title}}</h3>
    </div>
    <draggable v-model="questions" @end="saveQuestionOrder" handle=".handle">
      <edit-survey-question :question="q" v-for="q in questions" :key="q.id"></edit-survey-question>
    </draggable>
    <div v-if="!isLastPage(page.id)" class="mt-3">
      Po stronie {{i + 1}}
      <next-page-picker :for-page="page.id" :id="pagePickerId" class="ml-1" v-model="page.next_page_id"  @change="updatePage"></next-page-picker>
    </div>
    <b-modal v-if="isSelected" :id="deleteModalId" @ok="deletePage(page)" ok-title="Tak" cancel-variant="link" title="Czy na pewno usunąć stronę i pytania?">
      <p>{{SURVEY_CONFIRM_DELETE_PAGE_1}}</p>
      <p>{{SURVEY_CONFIRM_DELETE_PAGE_2}}</p>
    </b-modal>
  </div>
</template>

<script>
import EditSurveyQuestion from './edit-survey-question.vue';
import draggable from 'vuedraggable';
import NextPagePicker from './next-page-picker';
import { SAVE } from '../store/model.store'

import {
  SURVEY_CONFIRM_DELETE_PAGE_1,
  SURVEY_CONFIRM_DELETE_PAGE_2,
  QUESTION_ORDER_SAVE_SUCCESS,
 } from '../constants/strings';

import {
  pageMixin,
  surveyMixin,
  toastMixin,
  questionMixin
} from '@mixins';
import { questionModel } from '@/store/survey';

export default {
  name: "EditSurveyPage",
  components: {
    EditSurveyQuestion,
    draggable,
    NextPagePicker,
  },
  mixins: [
    surveyMixin,
    pageMixin,
    toastMixin,
    questionMixin
  ],
  props: {
    page: {
      type: Object,
      required: true
    },
    i: {
      type: Number,
      required: true
    },
    n: {
      type: Number,
      required: true
    }
  },
  data: () => ({
    SURVEY_CONFIRM_DELETE_PAGE_1,
    SURVEY_CONFIRM_DELETE_PAGE_2,
    questions: []
  }),
  computed: {
    isSelected() {
      return this.isSelectedPage(this.page) && !this.selectedQuestion
    },
    deleteModalId() {
      return `deletePage${this.selectedPage ? this.selectedPage.id : 0}`
    },
    pagePickerId() {
      return `page-picker-${this.page.id}`
    }
  },
  methods: {
    updatePage(arg) {
      this.page.next_page_action = arg != -1 ? 'next_page' : 'submit'
      this.page.next_page_id = arg
      this.savePage(this.page)
    },
    mergePageUp() {
      this.mergePage(this.page, this.getPreviousPage(this.page.id))
    },
    onPageClick() {
      this.unselectQuestion();
      this.selectPage(this.page);
    },
    saveQuestionOrder($event) {
      let question = this.questions[$event.newIndex]
      let item = {
        sort_order_position: $event.newIndex,
        _jv: {
          id: question.id,
          type: questionModel
        }
      }
      return this.toastPromise(this.$store.dispatch(SAVE, {model: questionModel, item, selected: false}), QUESTION_ORDER_SAVE_SUCCESS)
    }
  },
  watch: {
    page(newPage, oldPage) {
      if(newPage && (!oldPage || oldPage.id === newPage.id)) {
        this.questions = this.getPageQuestions(newPage)
      }
    }
  },
  mounted() {
    if(this.page) {
      this.questions = this.getPageQuestions(this.page)
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../stylesheets/style.scss';
.page {
  max-width: 60rem;
  min-width: 30rem;
  .page-title.selected {
    box-shadow: 0 0 10px 2px $color-secondary-1-1;
  }
  .page-label:after {
    background-color: $color-secondary-1-4;
    width: 100%;
    height: 6px;
    content: '';
    display: block;
  }

  .page-label span{
    display: inline-block;
    background-color: $color-secondary-1-4;
    padding: 0.2rem 2rem;
    color: white;
    border-radius: 1rem 1rem 0 0;
  }
}

.page ~ .page {
  .page-label:after {
    display: none;
  }
}

.next-page {
  width: 30rem;
}
</style>
