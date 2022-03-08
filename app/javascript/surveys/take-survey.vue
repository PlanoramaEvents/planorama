<template>
  <div class="survey scrollable">
    Loading...
  </div>
</template>

<script>
import {mapActions, mapMutations } from 'vuex';
import {
  pageMixin,
  surveyIdPropMixinId
} from '@mixins';
import { NEW_SUBMISSION, SET_PREVIEW_MODE } from '@/store/survey';

export default {
  name: "TakeSurvey",
  props: ['preview'],
  mixins: [
    surveyIdPropMixinId,
    pageMixin
  ],
  methods: {
    ...mapMutations({
      setPreviewMode: SET_PREVIEW_MODE
    }),
    ...mapActions({
      newSubmission: NEW_SUBMISSION,
    }),
  },
  mounted() {
    this.surveyLoadedPromise.then(() => {
      this.setPreviewMode(!!this.preview)
      if (!this.preview) {
        this.newSubmission({surveyId: this.id});
      }
      let path = `/surveys/${this.id}/page/${this.selectedPage.id}${this.preview ? '/preview' : ''}`
      // console.log('redirecting to ', path)
      this.$router.push({path})
    })
  }
}
</script>

<style lang="scss" scoped>
</style>
