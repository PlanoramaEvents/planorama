<!-- CONVERTED -->
<template>
  <div class="survey scrollable">
    Loading...
  </div>
</template>

<script>
import {mapMutations} from 'vuex';
import pageMixin from './page.mixin';
import { NEW_SUBMISSION } from '../store/survey.store';
import surveyIdPropMixin from './survey-id-prop.mixin';

export default {
  name: "TakeSurvey",
  props: ['preview'],
  mixins: [
    surveyIdPropMixin,
    pageMixin
  ],
  methods: {
    ...mapMutations({
      newSubmission: NEW_SUBMISSION,
    }),
  },
  mounted() {
    this.surveyLoadedPromise.then(() => {
      this.newSubmission();
      let path = `/${this.id}/page/${this.selectedPage.id}${this.preview ? '/preview' : ''}`
      console.log('redirecting to ', path)
      this.$router.push({path})
    })
  }
}
</script>

<style lang="scss" scoped>
</style>
