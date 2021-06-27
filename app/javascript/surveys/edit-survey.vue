<template>
  <div class="survey">
    <router-link to="/">Back</router-link>
    <edit-survey-controls></edit-survey-controls>
    <edit-survey-page
      v-for="(p, i) in survey ? survey.survey_pages : []"
      :key="p.id" :page="p" :i="i"
      :n="survey.survey_pages.length">
    </edit-survey-page>
  </div>
</template>

<script>
import EditSurveyPage from './edit-survey-page'
import EditSurveyControls from './edit-survey-controls'
import {mapState, mapMutations, mapActions} from 'vuex';
import { UNSELECT, SAVE, SELECT } from '../model.store';
import { SELECT_PAGE } from './survey.store';
import { Survey } from './survey';

export default {
  name: "EditSurvey",
  props: ['id'],
  components: {
    EditSurveyPage,
    EditSurveyControls,
  },
  computed: mapState({
    survey: 'selected',
    surveys: 'collection'
  }),
  methods: {
    ...mapMutations({
      unselect: UNSELECT,
      select: SELECT,
      selectPage: SELECT_PAGE
      }),
  },
  mounted() {
    console.log(this);
    if (!this.survey && this.id) {
      console.log('trying to load survey id', this.id)
      let model = new Survey({id: this.id}, this.surveys);
      model.fetch().then(() => {
        this.select(model);
        this.selectPage(model.survey_pages[0]);
      });
    }
  }
}
</script>

<style lang="scss" scoped>
.survey {
  overflow-y: scroll;
  max-height: calc(100vh - 100px);
}
</style>
