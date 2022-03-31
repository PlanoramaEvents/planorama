<template>
  <div class="pt-2">
    Do not schedule me against these specific  events:<br />
    <div class="d-flex flex-row align-content-around flex-wrap" >
      <div v-for="exclusion in currentSettings.exclusions" class="w-25">
        <b-form-checkbox
          v-model="selectedExclusions"
          :value="exclusion.id"
        >
          {{ exclusion.title }}
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
  props: {
  },
  data: () =>  ({
    selectedExclusions: []
  }),
  watch: {
    selectedExclusions(newVal, oldVal) {
      this.update_exclusions({person: this.currentUser, params: newVal})
    }
  },
  methods: {
    init: function(arg) {
      this.get_exclusions().then(
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
