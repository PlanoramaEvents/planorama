<template>
  <div :class="['survey-question', 'mt-3', 'border', 'p-3', {selected: isSelected}]" @click="selectQuestion(question)">
    <div class="handle d-flex justify-content-center"><b-icon-grip-horizontal></b-icon-grip-horizontal></div>
    <div v-if="!formatting && isSelected" class="row">
      <div class="col-5">
        <b-form-group
         :id="formGroupId('question-text')"
         label="Question Text"
         :label-for="formId('question-text')"
        >
          <b-form-input
            :id="formId('question-text')"
            v-model="question.question"
            type="text"
            @blur="save"
          ></b-form-input>
        </b-form-group>
      </div>
      <div class="col-6 offset-1">
        <b-form-group
          :id="formGroupId('question-type')"
          label="Question Type"
          :label-for="formId('question-type')"
        >
          <b-form-select :id="formId('question-type')" v-model="question.question_type" :options="questionTypes" @change="save"></b-form-select>
        </b-form-group>
      </div>
    </div>
    <div class="row" v-if="!formatting && !isSelected"> 
      <div class="col-12">
        <h4>{{question.question}}</h4>
      </div>
    </div>
    <div class="row">
      <template v-if="textfield">
        <div class="col-12">
          <small v-if="isSelected">Short answer text</small>
          <b-form-input v-if="!isSelected" type="text" disabled value="Short answer text"></b-form-input>
        </div>
      </template>
      <template v-if="textbox">
        <div class="col-12">
          <small v-if="isSelected">Long answer text</small>
          <b-textarea disabled v-if="!isSelected" value="Long answer text"></b-textarea>
        </div>
      </template>
      <options-question :question="question" v-if="singlechoice || multiplechoice || dropdown"></options-question>
      <template v-if="hr">
        <div class="col-12">
          <hr />
        </div>
      </template>
      <template v-if="address && !isSelected">
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('address-1')"
            :label-for="formId('address-1')"
            label="Address 1"
          >
            <b-form-input disabled :id="formId('address-1')"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('address-2')"
            :label-for="formId('address-2')"
            label="Address 2"
          >
            <b-form-input disabled :id="formId('address-2')"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('city')"
            :label-for="formId('city')"
            label="City"
          >
            <b-form-input disabled :id="formId('city')"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-3">
          <b-form-group
            :id="formGroupId('state')"
            :label-for="formId('state')"
            label="State"
          >
            <b-form-input disabled :id="formId('state')"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-3">
          <b-form-group
            :id="formGroupId('zip')"
            :label-for="formId('zip')"
            label="ZIP Code"
          >
            <b-form-input disabled :id="formId('zip')"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12">
          <b-form-group
            :id="formGroupId('country')"
            :label-for="formId('country')"
            label="Country"
          >
            <b-form-input disabled :id="formId('country')"></b-form-input>
          </b-form-group>
        </div>
      </template>
      <template v-if="address && isSelected">
        <div class="col-12">
          <small>Address fields</small>
        </div>
      </template>
      <template v-if="email">
        <div class="col-12">
          <b-form-input v-if="!isSelected" disabled type="email"></b-form-input>
          <small v-if="isSelected">Email field</small>
        </div>
      </template>
      <template v-if="socialmedia">
        <div class="col-12 col-lg-8 col-xl-6" v-if="!isSelected">
          <b-form-group label="Twitter" label-cols="3"><b-input-group prepend="@"><b-form-input type="text" disabled></b-form-input></b-input-group></b-form-group>
          <b-form-group label="Facebook" label-cols="3"><b-input-group>
            <template #prepend>
              <b-input-group-text>facebook.com&sol;</b-input-group-text>
            </template>
            <b-form-input type="text" disabled></b-form-input>
          </b-input-group></b-form-group>
          <b-form-group label="Website" label-cols="3"><b-input-group prepend="url"><b-form-input type="text" disabled></b-form-input></b-input-group></b-form-group>
          <b-form-group label="Instagram" label-cols="3"><b-input-group>
            <template #prepend>
              <b-input-group-text>instagram.com&sol;</b-input-group-text>
            </template>
            <b-form-input type="text" disabled></b-form-input>
          </b-input-group></b-form-group>
          <b-form-group label="Twitch" label-cols="3"><b-input-group>
            <template #prepend>
              <b-input-group-text>twitch.tv&sol;</b-input-group-text>
            </template>
            <b-form-input type="text" disabled></b-form-input>
          </b-input-group></b-form-group>
          <b-form-group label="YouTube" label-cols="3"><b-input-group>
            <template #prepend>
              <b-input-group-text>youtube.com&sol;channel&sol;</b-input-group-text>
            </template>
            <b-form-input type="text" disabled></b-form-input>
          </b-input-group></b-form-group>
          <b-form-group label="TikTok" label-cols="3"><b-input-group prepend="@"><b-form-input type="text" disabled></b-form-input></b-input-group></b-form-group>
          <b-form-group label="LinkedIn" label-cols="3"><b-input-group>
            <template #prepend>
              <b-input-group-text>linkedin.com&sol;in&sol;</b-input-group-text>
            </template>
            <b-form-input type="text" disabled></b-form-input>
          </b-input-group></b-form-group>
          <b-form-group label="Other" label-cols="3"><b-form-input type="text" disabled></b-form-input></b-form-group>
        </div>
        <div class="col-12">
          <small v-if="isSelected">Social Media fields</small>
        </div>
      </template>
      <template v-if="textonly">
        <div class="col-12">
          <b-form-textarea v-if="isSelected" v-model="question.question" @blur="save"></b-form-textarea>
          <p v-if="!isSelected">{{question.question}}</p>
        </div>
      </template>
    </div>
    <div class="row" v-if="isSelected">
      <div class="col-6">
        <b-form-checkbox inline v-if="!formatting" v-model="question.mandatory" @change="save">Required</b-form-checkbox>
        <b-form-checkbox inline v-if="singlechoice" v-model="question.branching" @change="save">Branching</b-form-checkbox>
      </div>
      <div class="col-6 d-flex justify-content-end">
        <b-button variant="info" class="mr-2" @click="duplicateQuestion"><b-icon-files></b-icon-files></b-button>
        <b-button variant="info" @click="destroyQuestion"><b-icon-trash></b-icon-trash></b-button>
      </div>
    </div>
  </div>
</template>

<script>
import { SurveyQuestion } from './survey_question'
import { createNamespacedHelpers } from 'vuex';
const { mapState, mapActions, mapMutations } = createNamespacedHelpers('surveys');
import { SAVE } from '../model.store';
import { NEW_QUESTION, SELECT_QUESTION, UNSELECT_QUESTION } from './survey.store';
import draggable from 'vuedraggable';
import surveyMixin from './survey.mixin';
import OptionsQuestion from './options-question.vue';
import pageMixin from './page.mixin';
import questionMixin from './question.mixin';


export default {
  name: "EditSurveyQuestion",
  components: {
    draggable,
    OptionsQuestion,
  },
  data: () => ({
    questionTypes: [
      { value: 'textfield', text: 'Short Answer'},
      { value: 'textbox', text: 'Long Answer'},
      { value: 'singlechoice', text: 'Multiple Choice' },
      { value: 'multiplechoice', text: 'Checkboxes' },
      { value: 'dropdown', text: 'Dropdown' },
      { value: 'address', text: 'Address' },
      { value: 'email', text: 'Email' },
      { value: 'socialmedia', text: 'Social Media' }
    ],
  }),
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
  computed: {
    ...mapState(['selected_question', 'selected_page']),
    answerIdMap() {
      if(!this.question.survey_answers) {
        return {}
      }
      return this.question.survey_answers.reduce((p, c) => ({
        ...p,
        [c.answer]: c.id
      }), {});

    },
    socialChoice: {
      get() {
        const answers = this.question.survey_answers; 
        return answers ? answers.map(qa => qa.answer) : [];
      },
      set(val) {
        this.question.survey_answers = val.map(answer => ({
          answer,
          id: this.answerIdMap[answer] || null
        }))
      }
    },
    socials() {
      return [
        {value: "twitter", text: "Twitter"},
        {value: "facebook", text: "Facebook"},
        {value: "twitch", text: "Twitch"},
        {value: "youtube", text: "YouTube"},
        {value: "instagram", text: "Instagram"},
        {value: "website", text: "Website"},
      ]
    },
  },
  methods: {
    ...mapMutations({
      selectQuestion: SELECT_QUESTION,
      unselectQuestion: UNSELECT_QUESTION,
    }),
    ...mapActions({
      newQuestion: NEW_QUESTION
    }),
    formId(string) {
      return `${string}-${this.question.id}`
    },
    formGroupId(string) {
      return `${this.formId(string)}-group`
    },
    destroyQuestion() {
      this.question._destroy = true
      this.save()
      this.unselectQuestion()
    },
    duplicateQuestion() {
      let new_question = {
        question: this.question.question,
        question_type: this.question.question_type,
        mandatory: this.question.mandatory,
        text_size: this.question.text_size,
        horizontal: this.question.horizontal,
        private: this.question.private,
        regex: this.question.regex,
        survey_page_id: this.question.survey_page_id,
        survey_answers: this.question.survey_answers.map(a => ({
          answer: a.answer,
          default: a.default,
          other: a.other,
        }))
      }
      let insertAt = this.selected_page.survey_questions.findIndex(q => q.id === this.question.id) + 1
      this.newQuestion({question: new_question, insertAt})
    },
  }
}
</script>

<style lang="scss">
@import '../stylesheets/style.scss';
.custom-control-label {
  width: 100%;
}
.handle, .qhandle {
  visibility: hidden;
}


.survey-question:hover .handle, .survey-answer:hover .qhandle{
  visibility: visible;
}

.survey-question.selected {
  box-shadow: 0 0 10px 2px $color-secondary-1-1;
}

.row-offset {
  width: calc(100% - 1em);
}
</style>
