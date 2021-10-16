<!-- CONVERTED -->
<template>
  <b-row>
    <b-col>
      <h2>Survey submitted</h2>
      <p>{{thankYou}}</p>
    </b-col>
  </b-row>
</template>

<script>
import surveyIdPropMixin from './survey-id-prop.mixin';
import { SURVEY_DEFAULT_THANK_YOU } from '../constants/strings';
export default {
  name: "SurveyThankYou",
  mixins: [surveyIdPropMixin],
  computed: {
    thankYou() {
      return this.survey?.thank_you || SURVEY_DEFAULT_THANK_YOU;
    }
  }
}
</script>

<style>

</style>
