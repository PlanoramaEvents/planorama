<template>
  <div class="survey scrollable">
    I am a survey!!!
    Loading...
  </div>
</template>

<script>
import { createNamespacedHelpers} from 'vuex';
const {mapState, mapMutations} = createNamespacedHelpers('surveys');
import { UNSELECT, SAVE, SELECT } from '../model.store';
import { NEW_SUBMISSION, SELECT_PAGE } from './survey.store';
import { Survey } from './survey';

export default {
  name: "TakeSurvey",
  props: ['id', 'preview'],
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
        let path = `/${this.id}/page/${this.survey.survey_pages[0].id}${this.preview ? '/preview' : ''}`
        console.log('redirecting to ', path)
        this.$router.push({path})
      }
  },
  mounted() {
    console.log(this);
    console.log('preview', this.preview);
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
</style>
