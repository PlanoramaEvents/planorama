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
        <b-form-input :id="'page-title-' + page.id" type="text" v-model="page.title" @change="save({item: selected})"></b-form-input>
      </b-form-group>
      <h3 v-if="!isSelected">{{page.title}}</h3>
    </div>
    <draggable v-model="page.survey_questions" @end="save(selected)" handle=".handle">
      <edit-survey-question :question="q" v-for="q in page.survey_questions" :key="q.id"></edit-survey-question>
    </draggable>
    <div v-if="i + 1 < n" class="mt-3">
      After section {{i + 1}}
      <b-select class="d-inline ml-1 next-page" v-model="page.next_page_id" :options="nextPageOptions" @change="save({item: selected})"></b-select>
    </div>
  </div>
</template>

<script>
import EditSurveyQuestion from './edit-survey-question.vue';
import { mapState, mapMutations, mapActions } from 'vuex';
import { SELECT_PAGE, UNSELECT_QUESTION } from './survey.store';
import { SAVE } from '../model.store';
import draggable from 'vuedraggable';

export default {
  name: "EditSurveyPage",
  components: { 
    EditSurveyQuestion,
    draggable, 
  },
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
  computed: {
    ...mapState(['selected_page', 'selected', 'selected_question']),
    isSelected() {
      return this.selected_page && this.page.id === this.selected_page.id && !this.selected_question;
    },
    onlyPage() {
      return this.n === 1;
    },
    nextPageOptions() {
      return [
        {value: this.selected.survey_pages[this.i + 1], text: 'Continue to next page'},
        ...this.selected.survey_pages.map((p, i) => ({
          value: p.id, text: `Go to section ${i + 1} (${p.title})`
        })),
        {value: null, text: 'Submit form'}
      ]
    }
  },
  methods: {
    ...mapMutations({
      selectPage: SELECT_PAGE
    }),
    ...mapActions({
      save: SAVE
    })
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
