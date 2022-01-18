<template>
  <b-modal
    size="xl"
    :title="title"
    ref='mailing-preview'
    scrollable
    @show='onShow'
  >
    <div>
      <b-button variant="primary" @click="onFirst"><<</b-button>
      <b-button variant="primary" @click="onPrev"><</b-button>
      <div class="d-inline" v-if="mailing.emails.length > 0">
        {{ mailing.emails[posn]}}
      </div>
      <b-button variant="primary" @click="onNext">></b-button>
      <b-button variant="primary" @click="onLast">>></b-button>
    </div>

    <br />
    <div v-if="preview">
      To: {{ preview.to }}<br />
      Subject: {{ preview.subject }}<br />
      <p v-html="preview.content"></p>
    </div>

    <template #modal-footer>
      <div class="w-100">
        <b-button
          variant="primary"
          size="sm"
          class="float-right"
          @click="onClose"
        >
          Close
        </b-button>
      </div>
    </template>
  </b-modal>
</template>

<script>
import {http as axios} from '../http';
import { mailingModel as model } from '../store/mailing.store'

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
    onClose() {
      this.$refs['mailing-preview'].hide()
    },
    showModal() {
      this.$refs['mailing-preview'].show()
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
