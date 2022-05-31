<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <b-form-group
          label="Notes"
          label-for="session-notes"
        >
          <b-form-textarea
            id="session-notes"
            v-model="selected.item_notes"
            rows="10"
            @blur="patchSelected({item_notes: selected.item_notes}, true)"
          ></b-form-textarea>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import { sessionModel as model} from '@/store/session.store'
import { modelMixinNoProp } from '@/mixins';

export default {
  name: "SessionNotes",
  mixins: [
    modelMixinNoProp
  ],
  data: () => ({
    model
  }),
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
