<template>
  <div>
    <b-form-group
      label="Notes"
      label-for="session-notes"
    >
      <b-form-textarea
        id="session-notes"
        v-model="session.item_notes"
        rows="10"
        @blur="saveSession()"
      ></b-form-textarea>
    </b-form-group>
  </div>
</template>

<script>
import { sessionModel } from '@/store/session.store'
import modelUtilsMixin from "@/store/model_utils.mixin";

export default {
  name: "SessionNotes",
  mixins: [
    modelUtilsMixin
  ],
  model: {
    prop: 'session'
  },
  props: {
    session: {
      type: Object,
      required: true
    }
  },
  methods: {
    saveSession() {
      this.save_model(sessionModel, this.session).then(
        (obj) => {
          this.$emit('input',obj)
        }
      )
    }
  }
}
</script>
