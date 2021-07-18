<template>
  <div class="col-12">
    <draggable v-model="question.survey_answers" @end="save" handle=".qhandle">
      <template v-for="(a, i) in question.survey_answers">
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
            <next-page-picker class="mt-n2 mb-2" :disabled="singlePage" v-if="isSelected" v-model="a.next_page_id"></next-page-picker>
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
          <next-page-picker class="mt-n2 mb-2" v-if="isSelected" v-model="other.next_page_id"></next-page-picker>
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
import { mapState } from 'vuex';
import surveyMixin from './survey-mixin';
import pageMixin from './page-mixin';
import questionMixin from './question.mixin';
import DropdownItem from './dropdown-item';
import NextPagePicker from './next-page-picker.vue';

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
  ],
  components: {
    draggable,
    DropdownItem,
    NextPagePicker,
  },
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
    addOption() {
      if (!this.question.survey_answers) {
        this.question.survey_answers = []
      }
      this.question.survey_answers.push({answer: 'Option'})
      this.save()
    },
    removeOption(answer) {
      answer._destroy = true;
      this.save()
    },
    addOther() {
      if (!this.question.survey_answers) {
        this.question.survey_answers = []
      }
      this.question.survey_answers.push({answer: 'Other', other: true})
      this.save()
    },
    removeOther() {
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
    }
  }
}
</script>

<style>

</style>
