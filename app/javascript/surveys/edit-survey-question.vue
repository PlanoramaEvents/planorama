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
      <template v-if="singlechoice">
        <template v-for="a in question.survey_answers">
          <div class="col-12" :key="a.id" v-if="!a.other">
            <div class="row">
              <div class="col-5 pb-2">
                <b-form-radio disabled>
                  <b-form-input v-if="isSelected" type="text" v-model="a.answer" @blur="save" class="mt-n2 mb-2"></b-form-input>
                  <span v-if="!isSelected">{{a.answer}}</span>
                </b-form-radio>
              </div>
              <div class="col-1 pb-2 text-center" v-if="isSelected">
                <b-icon-x @click="removeOption(a)" class="h3"></b-icon-x>
              </div>
            </div>
          </div>
        </template>
        <template v-if="other">
          <div class="col-5 pb-2" >
            <b-form-radio disabled><b-form-group label="Other" label-cols="2" class="mt-n2 mb-2"><b-form-input v-if="isSelected" type="text" disabled></b-form-input></b-form-group></b-form-radio>
          </div>
          <div class="col-1 pb-2 text-center" v-if="isSelected">
            <b-icon-x @click="removeOther" class="h3"></b-icon-x>
          </div>
        </template>
        <div class="col-12 pb-2" v-if="isSelected">
          <b-button @click="addOption" variant="link" class="ml-3">Add option</b-button>
          <div class="d-inline-block" v-if="!other" > or <b-button variant="link" @click="addOther">add "Other"</b-button></div>
        </div>
      </template>
      <template v-if="multiplechoice">
        <div class="col-12">
          <draggable v-model="question.survey_answers" @end="save(selected)" handle=".qhandle">
            <template v-for="a in question.survey_answers">
              <div class="row survey-answer" :key="a.id" v-if="!a.other">
                <div class="col-5 pb-2">
                  <div class="float-left qhandle" v-if="isSelected"><b-icon-grip-vertical></b-icon-grip-vertical></div>
                  <b-form-checkbox disabled class="ml-3">
                    <b-form-input v-if="isSelected" type="text" v-model="a.answer" @blur="save" class="mt-n2 mb-2"></b-form-input>
                    <span v-if="!isSelected">{{a.answer}}</span>
                  </b-form-checkbox>
                </div>
                <div class="col-1 pb-2 text-center" v-if="isSelected">
                  <b-icon-x @click="removeOption(a)" class="h3"></b-icon-x>
                </div>
              </div>
            </template>
          </draggable>
          <template v-if="other">
            <div class="row">
              <div class="col-5 pb-2">
                <b-form-checkbox disabled class="ml-3"><b-form-group label="Other" label-cols="2" class="mt-n2 mb-2"><b-form-input v-if="isSelected" type="text" disabled></b-form-input></b-form-group></b-form-checkbox>
              </div>
              <div class="col-1 pb-2 text-center" v-if="isSelected">
                <b-icon-x @click="removeOther" class="h3"></b-icon-x>
              </div>
            </div>
          </template>
          <div class="col-12 pb-2" v-if="isSelected">
            <b-button @click="addOption" variant="link">Add option</b-button>
            <div class="d-inline-block" v-if="!other" > or <b-button variant="link" @click="addOther">add "Other"</b-button></div>
          </div>
        </div>
      </template>
      <template v-if="hr">
        <div class="col-12">
          <hr />
        </div>
      </template>
      <template v-if="dropdown">
        <div class="col-12">
          <ol>
            <li class="pb-2" v-for="a in question.survey_answers" :key="a.id">
              <div class="row">
                <div class="col-11">
                  <b-form-input v-if="isSelected" v-model="a.answer" type="text" @blur="save"></b-form-input>
                  <span v-if="!isSelected">{{a.answer}}</span>
                </div>
                <div class="col-1" v-if="isSelected">
                  <b-icon-x @click="removeOption(a)"></b-icon-x>
                </div>
              </div>
            </li>
            <li class="pb-2" v-if="isSelected">
              <b-button @click="addOption" variant="link">Add Option</b-button>
            </li>
          </ol>
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
          <b-form-group label="Twitter" label-cols="3"><b-form-input type="text" disabled></b-form-input></b-form-group>
          <b-form-group label="Facebook" label-cols="3"><b-form-input type="text" disabled></b-form-input></b-form-group>
          <b-form-group label="Website" label-cols="3"><b-form-input type="text" disabled></b-form-input></b-form-group>
          <b-form-group label="Instagram" label-cols="3"><b-form-input type="text" disabled></b-form-input></b-form-group>
          <b-form-group label="Twitch" label-cols="3"><b-form-input type="text" disabled></b-form-input></b-form-group>
          <b-form-group label="YouTube" label-cols="3"><b-form-input type="text" disabled></b-form-input></b-form-group>
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
      <div class="col-12 d-flex justify-content-end">
        <b-button variant="info" class="mr-2" @click="duplicateQuestion"><b-icon-files></b-icon-files></b-button>
        <b-button variant="info" @click="destroyQuestion"><b-icon-trash></b-icon-trash></b-button>
      </div>
    </div>
  </div>
</template>

<script>
import { SurveyQuestion } from './survey_question'
import { mapState, mapActions, mapMutations } from 'vuex';
import { SAVE } from '../model.store';
import { NEW_QUESTION, SELECT_QUESTION, UNSELECT_QUESTION } from './survey.store';
import draggable from 'vuedraggable';


export default {
  name: "EditSurveyQuestion",
  components: {
    draggable,
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
  computed: {
    ...mapState(['selected', 'selected_question', 'selected_page']),
    textfield() {
      return this.question.question_type === "textfield";
    },
    textbox() {
      return this.question.question_type === "textbox";
    },
    singlechoice() {
      return this.question.question_type === "singlechoice";
    },
    multiplechoice() {
      return this.question.question_type === "multiplechoice";
    },
    hr() {
      return this.question.question_type === "hr";
    },
    dropdown() {
      return this.question.question_type === "dropdown";
    },
    address() {
      return this.question.question_type === "address";
    },
    email() {
      return this.question.question_type === "email";
    },
    socialmedia() {
      return this.question.question_type === "socialmedia";
    },
    textonly() {
      return this.question.question_type === "textonly";
    },
    other() {
      return this.question.survey_answers ? this.question.survey_answers.filter(a => a.other).length > 0 : false;
    },
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
    formatting() {
      return this.textonly || this.hr;
    },
    isSelected() {
      return this.selected_question && this.question.id === this.selected_question.id;
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
    save(event) {
      this.$store.dispatch(SAVE, {item: this.selected});
    },
    formId(string) {
      return `${string}-${this.question.id}`
    },
    formGroupId(string) {
      return `${this.formId(string)}-group`
    },
    addOption() {
      if (!this.question.survey_answers) {
        this.question.survey_answers = []
      }
      this.question.survey_answers.push({answer: undefined})
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
    destroyQuestion() {
      this.question._destroy = true
      console.log(this.question)
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
