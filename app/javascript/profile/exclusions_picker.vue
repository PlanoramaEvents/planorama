<template>
  <div class="mt-3">
    Nie planuj mnie na te konkretne wydarzenia:<br />
    <div class="d-flex flex-row align-content-around flex-wrap" >
      <div v-for="exclusion in currentSettings.exclusions" class="w-25">
        <b-form-checkbox
          v-model="selectedExclusions"
          :value="exclusion.id"
          @change="updateExclusions"
        >
          <small>{{ exclusion.title }}</small>
        </b-form-checkbox>
      </div>
    </div>
  </div>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";
import personExclusionMixin from '../store/person_exclusion.mixin'
import personSessionMixin from '../auth/person_session.mixin';

export default {
  name: "ExclusionsPicker",
  components: {
  },
  mixins: [
    settingsMixin,
    personSessionMixin,
    personExclusionMixin
  ],
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    },
  },
  data: () =>  ({
    selectedExclusions: []
  }),
  methods: {
    updateExclusions: function(vals) {
       this.update_exclusions({person: this.person, params: vals})
    },
    init: function(arg) {
      this.selectedExclusions = []
      this.get_exclusions({person: this.person}).then(
        () => {
          this.selectedExclusions = this.collection.map((a) => { return a.exclusion_id })
        }
      )
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style lang="scss">
</style>
