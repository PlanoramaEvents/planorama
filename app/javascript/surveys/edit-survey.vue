<template>
  <div class="survey">
    <b-button variant="link" @click="back">Back</b-button>
    <b-form-group
      class="mx-3"
      v-if="survey"
      id="survey-name-group"
      label="Survey Name"
      label-for="survey-name"
    >
      <b-form-input id="survey-name" type="text" v-model="survey.name" @blur="save"></b-form-input>
    </b-form-group>
    <b-form-group
      class="mx-3"
      v-if="survey"
      id="survey-description-group"
      label="Survey Description"
      label-for="survey-description"
    >
      <b-form-textarea id="survey-description" v-model="survey.description" @blur="save"></b-form-textarea>
    </b-form-group>
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
    save() {
      this.$store.dispatch(SAVE, {item: this.survey});
    },
    back() {
      // TODO only unselect if not coming from view page
      this.$store.commit(UNSELECT);
      this.$router.push('/');
    }
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
  overflow-y: auto;
  max-height: calc(100vh - 100px);
  .form-group {
    max-width: 60rem;
  }
}
</style>
