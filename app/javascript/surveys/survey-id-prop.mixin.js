import surveyMixin from "./survey.mixin";
import pageMixin from "./page.mixin";

// CONVERTED
const surveyIdPropMixin = (idProp = 'id') => ({
  props: [idProp],
  mixins: [
    surveyMixin,
    pageMixin
  ],
  data: () => ({
    surveyLoadedPromise: undefined
  }),
  mounted() {
    this.surveyLoadedPromise = new Promise((res, rej) =>  {
      if ((!this.survey && this[idProp]) || (this[idProp] && this.survey.id !== this[idProp])) {
        console.log('trying to load survey id', this[idProp])
        this.selectSurvey(this[idProp]);
        this.fetchSelectedSurvey().then(() => {
          this.selectPage(this.selectedSurveyFirstPage);
          res(true);
        }).catch(rej);
      } else {
        // didn't need to load, so we're good.
        res(false);
      }
    });
  }
});

export default surveyIdPropMixin;

export const surveyIdPropMixinId = surveyIdPropMixin();
export const surveyIdPropMixinSurveyId = surveyIdPropMixin('surveyId');
