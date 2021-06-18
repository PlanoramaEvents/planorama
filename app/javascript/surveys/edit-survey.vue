<template>
  <div class="survey">
    <router-link to="/">Back</router-link>
    <edit-survey-page
      v-for="p in survey ? survey.survey_pages : []"
      :key="p.id"
      :page="p">
    </edit-survey-page>
  </div>
</template>

<script>
import EditSurveyPage from './edit-survey-page'
import {mapState, mapMutations, mapActions} from 'vuex';
import { UNSELECT, SAVE, SELECT } from '../model.store';
import { Survey } from './survey';

export default {
  name: "EditSurvey",
  props: ['id'],
  components: {
    EditSurveyPage
  },
  computed: mapState({
    survey: 'selected',
    surveys: 'collection'
  }),
  methods: {
    ...mapMutations([UNSELECT]),
    ...mapActions([SAVE])
  },
  mounted() {
    console.log(this);
    if (!this.survey && this.id) {
      console.log('trying to load survey id', this.id)
      let model = new Survey({id: this.id}, this.surveys);
      model.fetch().then(() => {
        console.log(model);
        this.$store.commit(SELECT, model)
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
