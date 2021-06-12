<template>
  <div>
    <h3>{{question.title}}</h3>
    <p>{{question.question}}</p>
  </div>
</template>

<script>
import { SurveyQuestion } from './survey_question'

export default {
  name: "SurveyQuestion",
  props: {
    question: {
      type: SurveyQuestion,
      required: true
    }
  }, created() {
    console.log(this.question)
  }
}
</script>
