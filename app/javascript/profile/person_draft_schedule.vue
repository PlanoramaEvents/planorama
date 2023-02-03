<template>
  <person-schedule-display :sessions="sessions" title="Draft Schedule" approvalType="draft" :noSidebar="noSidebar"></person-schedule-display>
</template>

<script>
import { mapActions } from 'vuex';
import PersonScheduleDisplay from './person_schedule_display.vue';
import { personModel as model } from '@/store/person.store';
import { modelMixinNoProp } from '@/mixins';

export default {
  name: "PersonDraftSchedule",
  props: {
    noSidebar: {
      type: Boolean,
      default: false
    }
  },
  components: {
    PersonScheduleDisplay
  },
  mixins: [
    modelMixinNoProp,
  ],
  data: () => ({
    sessions: {},
    model,
  }),
  methods: {
    ...mapActions({
      get: 'jv/get'
    }),
    getSchedule() {
      if(this.selected) {
        this.get(`/person/${this.selected.id}/snapshot_schedule`).then(data => {
          const {_jv, ...filtered_data} = data;
          this.sessions = filtered_data;
        })
      }
    }
  },
  mounted() {
    this.getSchedule();
  },
  watch: {
    selected(newVal, oldVal) {
      if (newVal && newVal.id !== oldVal.id) {
        this.getSchedule()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
