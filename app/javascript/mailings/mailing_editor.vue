<template>
  <div>
    <mailing-preview :mailing="mailing"></mailing-preview>
    <plano-modal
      title="Zapisz Mailing"
      id="save-mailing-modal"
      @close="onClose"
      @cancel="onClose"
      @ok="onConfirmedSave"
      ok-title="Zapisz"
    >
      <b-form>
        <model-field label="Nazwa" v-model="mailing.title" type="text" stateless></model-field>
        <model-field label="Opis" v-model="mailing.description" type="textarea" stateless></model-field>
      </b-form>
    </plano-modal>
    <div class="d-flex ">
      <div class="p-2">{{ mailing.title }}</div>
      <div class="ml-auto p-2">
        <slot name="controls"></slot>
      </div>
    </div>
    <hr />
    <b-form-group
      label-cols-sm="3"
      label-cols-lg="2"
      content-cols-sm="9"
      content-cols-lg="10"
      label="Dodaj Adresy Email:"
      label-for="email-addresses"
    >
      <email-list-input id="email-addresses" v-model="mailing.emails" :disabled="readOnly"></email-list-input>
    </b-form-group>
    <b-form-group>
      <b-form-checkbox v-model="has_survey" :disabled="readOnly">
        Ten mailing posiada załączony ankietę
      </b-form-checkbox>
    </b-form-group>
    <b-form-group
      label-cols-sm="1"
      label-cols-lg="1"
    >
      <b-form-group
        label-cols-sm="3"
        label-cols-lg="2"
        content-cols-sm="9"
        content-cols-lg="10"
        label="Wybierz Ankietę:"
        label-for="email-survey"
      >
        <model-select
          v-model="mailing.survey_id"
          model="survey"
          filter='{"op":"all","queries":[["public", "=", "true"]]}'
          field="name"
          :disabled="has_survey == false"
        ></model-select>
      </b-form-group>
    </b-form-group>
    <b-form-group
      label-cols-sm="3"
      label-cols-lg="2"
      content-cols-sm="9"
      content-cols-lg="10"
      label="Temat:"
      label-for="email-subject"
    >
      <b-form-input id="email-subject" v-model="mailing.subject" :disabled="readOnly"></b-form-input>
    </b-form-group>
    <plano-editor
      v-model="mailing.content"
      type='classic'
      :show-mail-merge="true"
      :disabled="readOnly"
    ></plano-editor>
    <!-- TODO: put in sending to count -->
    <div class="d-flex justify-content-end" v-if="!readOnly">
      <b-button variant="primary" class="m-1 btn-sm" @click="onSave">Zapisz Mailing</b-button>
    </div>
    <div class="d-flex justify-content-end" v-if="!readOnly">
      <b-button variant="primary" class="m-1" @click="onSendTest">Wyślij test do siebie</b-button>
      <b-button variant="primary" class="m-1" @click="onPreview">Podgląd</b-button>
      <b-button variant="danger" class="m-1" @click="onSend">Wyślij</b-button>
    </div>
  </div>
</template>

<script>
import {http as axios} from '../http';
import modelMixin from '../store/model.mixin';
import { mailingModel as model } from '../store/mailing.store'
import EmailListInput from '../components/email_list_input'
import PlanoEditor from '@/components/plano_editor';
import PlanoModal from '@/components/plano_modal.vue';
import ModelField from '../shared/model-field';
import ModelSelect from '../components/model_select';
import toastMixin from '../shared/toast-mixin';
import MailingPreview from './mailing_preview';
import { MAILING_SCHEDULED } from '../constants/strings';
import { MAILING_TEST_SCHEDULED } from '../constants/strings';

import { mapActions } from 'vuex';
import { NEW_MAILING } from '../store/mailing.store';

export default {
  name: "MailingEditor",
  components: {
    EmailListInput,
    PlanoEditor,
    ModelField,
    ModelSelect,
    MailingPreview,
    PlanoModal,
  },
  mixins: [
    modelMixin,
    toastMixin
  ],
  props: {
    selectedId: {
      type: String,
      default: null
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      loading: true,
      mailing: this.starter_mailing(),
      has_survey: false,
      surveys: [],
      next_action: null
    }
  },
  watch: {
    has_survey(n,o) {
      if (n == false) {
        this.mailing.survey_id = null
      }
    }
  },
  methods: {
    ...mapActions({newMailingAction: NEW_MAILING}),
    onSave() {
      // How to so the show modal with different onConfirmedSave actions
      // Show dialog then save the actual entity
      this.$bvModal.show('save-mailing-modal');
    },
    onClose() {
      this.next_action = null
    },
    onSend() {
      this.next_action = 'send'
      this.onSave()
    },
    onSendTest() {
      this.next_action = 'send-test'
      this.onSave()
    },
    onPreview() {
      this.next_action = 'preview'
      this.onSave()
    },
    onConfirmedSave() {
      let res = this.save_or_update();
      res.then(
        (data) => {
          this.mailing = data
          this.$bvModal.hide('save-mailing-modal');
          if (this.next_action) {
            switch(this.next_action) {
              case 'send':
                this.performSend()
                break;
              case 'send-test':
                this.performSendTest()
                break;
              case 'preview':
                this.performPreview()
                break;
            }
            this.next_action = null
          }
        }
      )

      return res
    },
    save_or_update() {
      if (this.mailing.id == null) {
        return this.newMailingAction(this.mailing)
      } else {
        return this.save(this.mailing)
      }
    },
    performSend(res) {
      let url = `/mailing/schedule/${this.mailing.id}`
      axios.get(url).then(
        () => {
          this.$bvToast.toast(
            MAILING_SCHEDULED(this.mailing.title),
            {
              variant: 'success',
              title: 'Mail Scheduled'
            }
          )
          this.$emit('mailingSent')
        }
      )
    },
    performSendTest(res) {
      let recipient = this.mailing.emails[0]
      if (recipient) {
        let url = `/mailing/schedule/${this.mailing.id}/${recipient}/true`
        axios.get(url).then(
          () => {
            this.$bvToast.toast(
              MAILING_TEST_SCHEDULED(this.mailing.title),
              {
                variant: 'success',
                title: 'Mail Scheduled'
              }
            )
          }
        )
      }
    },
    performPreview(res) {
      this.$bvModal.show('mailing-preview');
    },
    starter_mailing() {
      return {
        id: null,
        title: '',
        survey_id: null,
        emails: [], //['test@test.com'],
        subject: '',
        content: '',
        description: '',
        testrun: false
      }
    },
    init() {
      if (this.selectedId == null) {
        this.has_survey = false
        this.mailing = this.starter_mailing()
        return
      }

      this.loading = true
      this.fetch_by_id(
        this.selectedId
      ).then(data => {
        this.mailing = data
        this.loading = false
        this.has_survey = data.survey_id != null
      })
    }
  },
  mounted() {
    this.init()
  }
}
</script>
