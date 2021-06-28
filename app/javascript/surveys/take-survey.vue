<template>
  <div class="survey">
    I am a survey!!!
    Loading...
  </div>
</template>

<script>
import {mapState, mapMutations, mapActions} from 'vuex';
import { UNSELECT, SAVE, SELECT } from '../model.store';
import { NEW_SUBMISSION, SELECT_PAGE } from './survey.store';
import { Survey } from './survey';

export default {
  name: "TakeSurvey",
  props: ['id'],
  components: {
  },
  computed: mapState({
    survey: 'selected',
    surveys: 'collection'
  }),
  methods: {
    ...mapMutations({
      unselect: UNSELECT,
      select: SELECT,
      selectPage: SELECT_PAGE,
      newSubmission: NEW_SUBMISSION,
      }),
      redirect() {
        this.selectPage(this.survey.survey_pages[0]);
        this.newSubmission();
        let path = `/${this.id}/page/${this.survey.survey_pages[0].id}`
        console.log('redirecting to ', path)
        this.$router.push({path})
      }
  },
  mounted() {
    console.log(this);
    if (!this.survey && this.id) {
      console.log('trying to load survey id', this.id)
      let model = new Survey({id: this.id}, this.surveys);
      model.fetch().then(() => {
        this.select(model);
        this.redirect();
      });
    }
    else {
      this.redirect();
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
