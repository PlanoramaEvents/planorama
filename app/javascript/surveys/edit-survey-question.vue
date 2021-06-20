<template>
  <div class="survey-question m-3 border p-3" @click="selectQuestion(question)">
    <div v-if="!formatting && isSelected" class="row">
      <div class="col-6">
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
      <div class="col-6">
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
          <small>Short answer text</small>
        </div>
      </template>
      <template v-if="textbox">
        <div class="col-12">
          <small>Long answer text</small>
        </div>
      </template>
      <template v-if="singlechoice">
        <template v-for="a in question.survey_answers">
          <div class="col-11 pb-2" :key="a.id" v-if="a.answer != 'other'">
            <b-form-radio disabled>
              <b-form-input v-if="isSelected" type="text" v-model="a.answer" @blur="save"></b-form-input>
              <span v-if="!isSelected">{{a.answer}}</span>
            </b-form-radio>
          </div>
          <div class="col-1 pb-2" :key="a.id + '-delete'" v-if="a.answer != 'other' && isSelected">
            <b-icon-x @click="removeOption(a)"></b-icon-x>
          </div>
        </template>
        <template v-if="other">
          <div class="col-11 pb-2" >
            <b-form-radio disabled>Other <b-form-input v-if="isSelected" type="text" disabled></b-form-input></b-form-radio>
          </div>
          <div class="col-1 pb-2" v-if="isSelected">
            <b-icon-x @click="removeOther"></b-icon-x>
          </div>
        </template>
        <div class="col-12 pb-2" v-if="isSelected">
          <b-form-radio disabled>
            <b-button @click="addOption" variant="link">Add Option</b-button>
            <div class="d-inline-block" v-if="!other" > or <b-button variant="link" @click="addOther">add other</b-button></div>
          </b-form-radio>
        </div>
      </template>
      <template v-if="multiplechoice">
        <template v-for="a in question.survey_answers">
          <div class="col-11 pb-2" :key="a.id" v-if="a.answer != 'other'">
            <b-form-checkbox disabled>
              <b-form-input v-if="isSelected" type="text" v-model="a.answer" @blur="save"></b-form-input>
              <span v-if="!isSelected">{{a.answer}}</span>
            </b-form-checkbox>
          </div>
          <div class="col-1 pb-2" :key="a.id + '-delete'" v-if="a.answer != 'other' && isSelected">
            <b-icon-x @click="removeOption(a)"></b-icon-x>
          </div>
        </template>
        <template v-if="other">
          <div class="col-11 pb-2">
            <b-form-checkbox disabled>Other <b-form-input v-if="isSelected" type="text" disabled></b-form-input></b-form-checkbox>
          </div>
          <div class="col-1 pb-2" v-if="isSelected">
            <b-icon-x @click="removeOther"></b-icon-x>
          </div>
        </template>
        <div class="col-12 pb-2" v-if="isSelected">
          <b-form-checkbox disabled>
            <b-button @click="addOption" variant="link">Add Option</b-button>
            <div class="d-inline-block" v-if="!other" > or <b-button variant="link" @click="addOther">add other</b-button></div>
          </b-form-checkbox>
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
      <template v-if="address && isSelected">
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('address-1')"
            :label-for="formId('address-1')"
            label="Address 1"
          >
            <b-form-input disabled :id="formId('address-1')" value="123 Sesame Street"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('address-2')"
            :label-for="formId('address-2')"
            label="Address 2"
          >
            <b-form-input disabled :id="formId('address-2')" value="Apt. 2B"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-6">
          <b-form-group
            :id="formGroupId('city')"
            :label-for="formId('city')"
            label="City"
          >
            <b-form-input disabled :id="formId('city')" value="New York"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-3">
          <b-form-group
            :id="formGroupId('state')"
            :label-for="formId('state')"
            label="State"
          >
            <b-form-input disabled :id="formId('state')" value="NY"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12 col-sm-3">
          <b-form-group
            :id="formGroupId('zip')"
            :label-for="formId('zip')"
            label="ZIP Code"
          >
            <b-form-input disabled :id="formId('zip')" value="12345"></b-form-input>
          </b-form-group>
        </div>
        <div class="col-12">
          <b-form-group
            :id="formGroupId('country')"
            :label-for="formId('country')"
            label="Country"
          >
            <b-form-input disabled :id="formId('country')" value="USA"></b-form-input>
          </b-form-group>
        </div>
      </template>
      <template v-if="address && !isSelected">
        <div class="col-12">
          <small>Address fields</small>
        </div>
      </template>
      <template v-if="email">
        <div class="col-12">
          <b-form-input v-if="isSelected" disabled type="email" value="example@example.com"></b-form-input>
          <small v-if="!isSelected">Email field</small>
        </div>
      </template>
      <template v-if="socialmedia">
        <div class="col-12">
          <b-form-checkbox-group :disabled="!isSelected" v-model="socialChoice" :options="socials" @change="save">
          </b-form-checkbox-group>
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
        <b-button variant="info" class="mr-2"><b-icon-files></b-icon-files></b-button>
        <b-button variant="info" @click="destroyQuestion"><b-icon-trash></b-icon-trash></b-button>
      </div>
    </div>
  </div>
</template>

<script>
import { SurveyQuestion } from './survey_question'
import { mapState, mapActions, mapMutations } from 'vuex';
import { SAVE } from '../model.store';
import { SELECT_QUESTION, UNSELECT_QUESTION } from './survey.store';


export default {
  name: "EditSurveyQuestion",
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
    ...mapState(['selected', 'selected_question']),
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
      // specifically undefined because if we add it, we're setting it to null explicitly
      return this.answerIdMap.other !== undefined;
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
        {value: "linkedin", text: "LinkedIn"},
        {value: "twitch", text: "Twitch"},
        {value: "youtube", text: "YouTube"},
        {value: "instagram", text: "Instagram"},
        {value: "flickr", text: "Flickr"},
        {value: "reddit", text: "Reddit"},
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
      unselectQuestion: UNSELECT_QUESTION
    }),
    save(event) {
      this.$store.dispatch(SAVE, this.selected);
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
      this.question.survey_answers.push({answer: 'other'})
      this.save()
    },
    removeOther() {
      this.question.survey_answers.filter(a => a.answer === 'other')[0]._destroy = true;
      this.save()
    },
    destroyQuestion() {
      this.question._destroy = true
      console.log(this.question)
      this.save()
      this.unselectQuestion()
    }
  }
}
</script>

<style lang="scss">
.custom-control-label {
  width: 100%;
}
</style>
