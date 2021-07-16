<template>
  <div class="page m-3">
    <div class="page-label">
      <span :class="[onlyPage ? 'd-none' : 'd-inline-block']">Page {{i + 1}} of {{n}} </span>
    </div>
    <div :class="['page-title', 'p-3', 'border', {selected: isSelected}]" @click="selectPage(page)">
      <b-form-group
        v-if="isSelected"
        :label="i === 0 ? 'Display Title' : 'Page Title'"
        :label-for="'page-title-' + page.id"
      >
        <b-form-input :id="'page-title-' + page.id" type="text" v-model="page.title" @change="save"></b-form-input>
      </b-form-group>
      <div class="row" v-if="isSelected && i !== 0">
        <div class="col-12 d-flex justify-content-end">
          <b-button variant="info" title="Merge page up" class="mr-2" v-b-modal.mergePageUp><b-icon-arrow-up-circle-fill></b-icon-arrow-up-circle-fill></b-button>
          <b-button variant="info" title="Delete page" v-b-modal.deletePage><b-icon-trash></b-icon-trash></b-button>
        </div>
      </div>
      <h3 v-if="!isSelected">{{page.title}}</h3>
    </div>
    <draggable v-model="page.survey_questions" @end="save" handle=".handle">
      <edit-survey-question :question="q" v-for="q in page.survey_questions" :key="q.id"></edit-survey-question>
    </draggable>
    <div v-if="i + 1 < n" class="mt-3">
      After section {{i + 1}}
      <b-select class="d-inline ml-1 next-page" v-model="page.next_page_id" :options="nextPageOptions" @change="save"></b-select>
    </div>
    <b-modal v-if="isSelected" id="mergePageUp" @ok="mergePage" ok-title="Yes" cancel-variant="link">
      <p>{{SURVEY_CONFIRM_MERGE_PAGE}}</p>
    </b-modal>
    <b-modal v-if="isSelected" id="deletePage" @ok="destroyPage" ok-title="Yes" cancel-variant="link" title="Delete page and questions?">
      <p>{{SURVEY_CONFIRM_DELETE_PAGE_1}}</p>
      <p>{{SURVEY_CONFIRM_DELETE_PAGE_2}}</p>
    </b-modal>
  </div>
</template>

<script>
import EditSurveyQuestion from './edit-survey-question.vue';
import { mapState, mapMutations, mapActions } from 'vuex';
import { SELECT_PAGE, UNSELECT_PAGE, UNSELECT_QUESTION } from './survey.store';
import { SAVE } from '../model.store';
import draggable from 'vuedraggable';
import surveyMixin from './survey-mixin';
import { 
  SURVEY_CONFIRM_DELETE_PAGE_1, 
  SURVEY_CONFIRM_DELETE_PAGE_2,
  SURVEY_CONFIRM_MERGE_PAGE,
 } from '../constants/strings';

export default {
  name: "EditSurveyPage",
  components: { 
    EditSurveyQuestion,
    draggable, 
  },
  mixins: [surveyMixin],
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
    SURVEY_CONFIRM_MERGE_PAGE
  }),
  computed: {
    ...mapState(['selected_page', 'selected_question']),
    isSelected() {
      return this.selected_page && this.page.id === this.selected_page.id && !this.selected_question;
    },
    onlyPage() {
      return this.n === 1;
    },
    nextPageOptions() {
      return [
        {value: this.survey.survey_pages[this.i + 1], text: 'Continue to next page'},
        ...this.survey.survey_pages.map((p, i) => ({
          value: p.id, text: `Go to section ${i + 1} (${p.title})`
        })),
        {value: null, text: 'Submit form'}
      ]
    }
  },
  methods: {
    ...mapMutations({
      selectPage: SELECT_PAGE,
      unselectPage: UNSELECT_PAGE,
    }),
    mergePage() {
      let prev_page = this.survey.survey_pages[this.i - 1];
      this.survey.moveQuestions(this.selected_page.survey_questions.map(q => q.id), prev_page.id)
      this.destroyPage()
    },
    destroyPage() {
      this.selected_page._destroy = true;
      for (let question of this.selected_page.survey_questions) {
        question._destroy = true;
      }
      console.log(this.selected_page);
      this.unselectPage();
      this.save();
    },
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
