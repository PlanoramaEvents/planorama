<template>
  <div class="col-12">
    <draggable v-model="answers" @end="saveAnswerOrder" handle=".qhandle">
      <template v-for="(a, i) in answers">
        <div class="row survey-answer" :key="a.id" v-if="!a.other">
          <div class="col-5 pb-2">
            <div class="float-left qhandle" v-if="isSelected"><b-icon-grip-vertical></b-icon-grip-vertical></div>
            <component :is="optionComponent" disabled class="ml-3" :i="i + 1">
              <b-form-input v-if="isSelected" type="text" v-model="a.answer" @blur="save" class="mt-n2 mb-2"></b-form-input>
              <span v-if="!isSelected">{{a.answer}}</span>
            </component>
          </div>
          <div class="col-1 pb-2 text-center" v-if="isSelected">
            <b-icon-x @click="removeOption(a)" class="h3"></b-icon-x>
          </div>
          <div class="col-6" v-if="singlechoice && question.branching">
            <next-page-picker :id="pagePickerId(a)" class="mt-n2 mb-2" :disabled="singlePage" v-if="isSelected" v-model="a.next_page_id"></next-page-picker>
          </div>
        </div>
      </template>
    </draggable>
    <template v-if="other">
      <div class="row">
        <div class="col-5 pb-2">
          <component :is="optionComponent" disabled class="ml-3"><b-form-group label="Other" label-cols="2" class="mt-n2 mb-2"><b-form-input v-if="isSelected" type="text" disabled></b-form-input></b-form-group></component>
        </div>
        <div class="col-1 pb-2 text-center" v-if="isSelected">
          <b-icon-x @click="removeOther" class="h3"></b-icon-x>
        </div>
        <div class="col-6" v-if="singlechoice && question.branching">
          <next-page-picker :id="pagePickerId(other)" class="mt-n2 mb-2" :disabled="singlePage" v-if="isSelected" v-model="other.next_page_id"></next-page-picker>
        </div>
      </div>
    </template>
    <div class="col-12 pb-2" v-if="isSelected">
      <b-button @click="addOption" variant="link">Add option</b-button>
      <div class="d-inline-block" v-if="!other && !dropdown" > or <b-button variant="link" @click="addOther">add "Other"</b-button></div>
    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable';

import {
  surveyMixin,
  pageMixin,
  questionMixin,
  answerMixin
} from '@mixins';
import DropdownItem from './dropdown-item';
import NextPagePicker from './next-page-picker.vue';
import { answerModel, questionModel } from '../store/survey.store'
import { mapActions } from 'vuex';
import { SAVE } from '../store/model.store';

export default {
  name: 'OptionsQuestion',
  props: {
    question: {
      type: Object,
      required: true
    },
  },
  mixins: [
    surveyMixin,
    pageMixin,
    questionMixin,
    answerMixin
  ],
  components: {
    draggable,
    DropdownItem,
    NextPagePicker,
  },
  data: () => ({
    answers: []
  }),
  computed: {
    optionComponent() {
      switch(this.question.question_type) {
        case "singlechoice":
          return "BFormRadio";
          break;
        case "multiplechoice":
          return "BFormCheckbox";
          break;
        case "dropdown":
          return "DropdownItem";
          break;
        default:
          return "BFormInput";
      }
    },
  },
  methods: {
    ...mapActions({
      save: SAVE
    }),
    pagePickerId(answer) {
      return `page-picker-answer-${answer.id}`
    },
    addOption() {
      let item = {
        answer: 'Option',
        _jv: {
          type: answerModel,
          relationships: {
            question: {
              data: {
                id: this.question.id,
                type: questionModel
              }
            }
          }
        }
      }
      this.saveAnswer(item).then((data) => {
        // what comes back here
        console.log(data)
        // TODO assign to this.answers
      })
    },
    removeOption(answer) {
      // TODO i stopped here
      answer._destroy = true;
      this.save()
    },
    addOther() {
      let item = {
        answer: 'Other',
        other: true,
        _jv: {
          type: answerModel,
          relationships: {
            question: {
              data: {
                id: this.question.id,
                type: questionModel
              }
            }
          }
        }
      }
      this.saveAnswer(item).then((data) => {
        // what comes back here
        console.log(data)
        // TODO assign to this.answers
      })
    },
    removeOther() {
      // TODO
      this.question.survey_answers.filter(a => a.other)[0]._destroy = true;
      this.save()
    },
    goesToPage(id) {
      if(id > 0)
        return `Goes to page ${this.getPageDescriptor(id)}`;
      if (id == -1) {
        return "Submits survey"
      }
      return "Continues to next page"
    },
    saveAnswerOrder($event) {
      // the answers array is totally decoupled from the question at this point
      // thing to save
      let answer = this.answers[$event.newIndex]
      let item = {
        sort_order_position: $event.newIndex,
        _jv: {
          id: answer.id,
          type: answerModel
        }
      }
      console.log("item", item)
      this.saveAnswer(item).then((data) => {
        // what comes back here
        console.log(data)
        // TODO assign to this.answers
      })
    }
  },
  mounted() {
    this.answers = this.getQuestionAnswers(this.question);
    console.log('this.answers', this.answers)
  }
}
</script>

<style>

</style>
