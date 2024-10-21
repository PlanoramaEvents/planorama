<template>
  <div class="survey">
    Loading...
  </div>
</template>

<script>
import {mapActions, mapMutations } from 'vuex';
import {
  pageMixin,
  surveyIdPropMixinId
} from '@/mixins.js';
import { NEW_SUBMISSION, SET_PREVIEW_MODE, SHOW_REDIR } from '@/store/survey';

export default {
  name: "TakeSurvey",
  props: ['preview'],
  mixins: [
    surveyIdPropMixinId,
    pageMixin
  ],
  methods: {
    ...mapMutations({
      setPreviewMode: SET_PREVIEW_MODE,
      showRedir: SHOW_REDIR
    }),
    ...mapActions({
      newSubmission: NEW_SUBMISSION,
    }),
  },
  mounted() {
    this.surveyLoadedPromise.then(() => {
      this.setPreviewMode(this.preview === "preview")
      if (this.preview !== "preview") {
        this.newSubmission({surveyId: this.id});
      }
      if (this.preview === 'redir') {
        this.showRedir();
      }
      let path = `/surveys/${this.id}/page/${this.selectedPage.id}${this.preview === 'preview' ? `/preview` : ''}`
      // console.log('redirecting to ', path)
      this.$router.push({path})
    })
  }
}
</script>

<style lang="scss" scoped>
</style>
