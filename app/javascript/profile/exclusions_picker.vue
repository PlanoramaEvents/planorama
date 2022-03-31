<template>
  <div class="pt-2">
    Do not schedule me against these specific  events:<br />
    <div class="d-flex flex-row align-content-around flex-wrap" >
      <div v-for="exclusion in currentSettings.exclusions" class="w-25">
        <b-form-checkbox
          v-model="selected"
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
// import { sessionModel } from '@/store/sessionP.store'
// TODO: need to get the person's exclusions ....
import personSessionMixin from '../auth/person_session.mixin';
// personExclusionMixin

export default {
  name: "ExclusionsPicker",
  components: {
  },
  mixins: [
    settingsMixin,
    personSessionMixin
  ],
  props: {
  },
  data: () =>  ({
    selected: []
  }),
  watch: {
    selected(newVal, oldVal) {
      console.debug("**** ", newVal)
      // ??? do we save on selected
      // if (newVal) {
      //   this.init()
      // }
    }
  },
  computed: {
  },
  methods: {
    // TODO: when selected changes we need to save ....
  }
}
</script>

<style lang="scss">
</style>
