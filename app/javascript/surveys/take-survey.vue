<!-- CONVERTED -->
<template>
  <div class="survey scrollable">
    Loading...
  </div>
</template>

<script>
import {mapActions} from 'vuex';
import pageMixin from './page.mixin';
import { NEW_SUBMISSION } from '../store/survey.store';
import { surveyIdPropMixinId } from './survey-id-prop.mixin';

export default {
  name: "TakeSurvey",
  props: ['preview'],
  mixins: [
    surveyIdPropMixinId,
    pageMixin
  ],
  methods: {
    ...mapActions({
      newSubmission: NEW_SUBMISSION,
    }),
  },
  mounted() {
    this.surveyLoadedPromise.then(() => {
      this.newSubmission({surveyId: this.id});
      let path = `/surveys/${this.id}/page/${this.selectedPage.id}${this.preview ? '/preview' : ''}`
      console.log('redirecting to ', path)
      this.$router.push({path})
    })
  }
}
</script>

<style lang="scss" scoped>
</style>
