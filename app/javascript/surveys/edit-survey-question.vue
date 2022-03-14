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

          <plano-editor
            :id="formId('question-text')"
            v-model="question.question"
            @blur="patchSelectedQuestion({question: $event.editor._.data})"
          ></plano-editor>
        </b-form-group>
      </div>
      <div class="col-6 offset-1">
        <b-form-group
          :id="formGroupId('question-type')"
          label="Question Type"
          :label-for="formId('question-type')"
        >
          <b-form-select :id="formId('question-type')" v-model="question.question_type" :options="questionTypes" @change="patchSelectedQuestion({question_type: $event})"></b-form-select>
        </b-form-group>
      </div>
      <div class="offset-6 col-6">
        <linked-field :question="question"></linked-field>
      </div>
    </div>
    <div class="row" v-if="!formatting && !isSelected">
      <div :class="{'col-12': !question.linked_field, 'col-6': question.linked_field}">
        <div v-html="question.question" class="py-3"></div>
      </div>
      <div v-if="question.linked_field" class="text-right col-6">
        Linked field: {{question.linked_field}}
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
          <b-form-textarea v-if="isSelected" v-model="question.question" @blur="patchSelectedQuestion({question: $event.target.value})"></b-form-textarea>
          <p v-if="!isSelected">{{question.question}}</p>
        </div>
      </template>
    </div>
    <div class="row" v-if="isSelected">
      <div class="col-6">
        <b-form-checkbox inline v-if="!formatting" v-model="question.mandatory" @change="patchSelectedQuestion({mandatory: $event})">Required</b-form-checkbox>
        <b-form-checkbox inline v-if="!formatting" v-model="question.private" @change="patchSelectedQuestion({private: $event})">Sensitive</b-form-checkbox>
        <b-form-checkbox inline v-if="singlechoice" v-model="question.branching" @change="patchSelectedQuestion({branching: $event})">Branching</b-form-checkbox>
      </div>
      <div class="col-6 d-flex justify-content-end">
        <b-button variant="info" class="mr-2" @click="duplicateSelectedQuestion"><b-icon-files></b-icon-files></b-button>
        <b-button variant="info" @click="deleteSelectedQuestion"><b-icon-trash></b-icon-trash></b-button>
      </div>
    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable';
import OptionsQuestion from './options-question.vue';
import PlanoEditor from '@/components/plano_editor';
import LinkedField from './linked-field';
import {
  surveyMixin,
  pageMixin,
  questionMixin
} from '@mixins';


export default {
  name: "EditSurveyQuestion",
  components: {
    draggable,
    OptionsQuestion,
    PlanoEditor,
    LinkedField,
  },
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
    formId(string) {
      return `${string}-${this.question.id}`
    },
    formGroupId(string) {
      return `${this.formId(string)}-group`
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
