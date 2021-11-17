import surveyMixin from "./survey.mixin";
import pageMixin from "./page.mixin";
import { mapMutations } from "vuex";
import { SET_PREVIEW_MODE } from "../store/survey/survey.actions";

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
  methods: {
    ...mapMutations({
      setPreviewMode: SET_PREVIEW_MODE
    })
  },
  mounted() {
    this.surveyLoadedPromise = new Promise((res, rej) =>  {
      if ((!this.survey && this[idProp]) || (this[idProp] && this.survey.id !== this[idProp])) {
        console.debug('trying to load survey id', this[idProp])
        this.selectSurvey(this[idProp]);
        this.setPreviewMode(false);
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

export const surveyIdPropMixinId = surveyIdPropMixin('id');
export const surveyIdPropMixinSurveyId = surveyIdPropMixin('surveyId');
