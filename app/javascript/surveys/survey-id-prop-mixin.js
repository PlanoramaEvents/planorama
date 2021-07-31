import surveyMixin from "./survey-mixin";
import { mapMutations, mapState } from "vuex";
import { SELECT } from "../model.store";
import { SELECT_PAGE } from './survey.store'
import { Survey } from './survey'

const surveyIdPropMixin = {
  props: ['id'],
  mixins: [surveyMixin],
  computed: mapState({
    surveys: 'collection'
  }),
  methods: mapMutations({
    select: SELECT,
    selectPage: SELECT_PAGE
  }),
  mounted() {
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

export default surveyIdPropMixin;
