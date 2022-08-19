<template>
  <b-modal
    size="xl"
    :title="title"
    id="mailing-preview"
    scrollable
    @show='onShow'
    ok-title="Close"
    ok-only
  >
    <div>
      <b-button variant="primary" @click="onFirst" :disabled="!posn">&lt;&lt;</b-button>
      <b-button variant="primary" @click="onPrev" :disabled="!posn">&lt;</b-button>
      <div class="d-inline" v-if="mailing.emails.length > 0">
        {{ mailing.emails[posn]}}
      </div>
      <b-button variant="primary" @click="onNext" :disabled="posn === mailing.emails.length - 1">&gt;</b-button>
      <b-button variant="primary" @click="onLast" :disabled="posn === mailing.emails.length - 1">&gt;&gt;</b-button>
    </div>
    <div v-if="preview" class="mt-3">
      To: {{ preview.to }}<br />
      Subject: {{ preview.subject }}<br />
      <p v-html="preview.content"></p>
    </div>
  </b-modal>
</template>

<script>
import {http as axios} from '../http';

export default {
  name: "MailingPreview",
  props: {
    title: {
      type: String,
      default: 'Preview Mailing'
    },
    mailing: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      preview: null,
      posn: null
    }
  },
  watch: {
    posn(newVal, oldVal) {
      if (newVal != oldVal) {
        this.getPreview()
      }
    }
  },
  methods: {
    onFirst() {
      this.posn = 0
    },
    onPrev() {
      if (this.posn > 0) {
        this.posn -= 1
      }
    },
    onNext() {
      if (this.posn < this.mailing.emails.length) {
        this.posn += 1
      }
    },
    onLast() {
      this.posn = this.mailing.emails.length - 1
    },
    getPreview() {
      if (this.mailing && (this.posn >= 0) && (this.posn < this.mailing.emails.length)) {
        let recipient = this.mailing.emails[this.posn]
        let url = `/mailing/preview/${this.mailing.id}/${recipient}`
        axios.get(url).then(
          (res) => {
            this.preview = res.data
          }
        )
      }
    },
    onShow() {
      this.posn = 0
    }
  }
}
</script>

<style>

</style>
