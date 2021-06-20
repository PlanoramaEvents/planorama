<template>
  <div class="page">
    <div class="page-label mt-3 mx-3">
      <span :class="[onlyPage ? 'd-none' : 'd-inline-block']">Page {{i + 1}} of {{n}} </span>
    </div>
    <h3 class="mb-3 mx-3 p-3 border" @click="selectPage(page)">
      <b-form-input type="text" v-model="page.title" v-if="isSelected" @change="save(selected)"></b-form-input>
      <span v-if="!isSelected">{{page.title}}</span>
    </h3>
    <draggable v-model="page.survey_questions" @end="save(selected)">
      <edit-survey-question :question="q" v-for="q in page.survey_questions" :key="q.id"></edit-survey-question>
    </draggable>
    <div v-if="i + 1 < n">
      After section {{i + 1}}
      <b-select class="d-inline ml-1 next-page" v-model="page.next_page_id" :options="nextPageOptions" @change="save(selected)"></b-select>
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
.page {
  width: 90%;
}
.next-page {
  width: 30rem;
}
</style>
