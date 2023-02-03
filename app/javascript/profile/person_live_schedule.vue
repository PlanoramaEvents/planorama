<template>
  <person-schedule-display :sessions="sessions" :title="liveScheduleTitle" :approvalType="firmSchedule ? 'firm' : null" :noSidebar="noSidebar"></person-schedule-display>
</template>

<script>
import { mapActions } from 'vuex';
import PersonScheduleDisplay from './person_schedule_display.vue';
import { personModel as model } from '@/store/person.store';
import { modelMixinNoProp } from '@/mixins';
import { scheduleWorkflowMixin } from '@/store/schedule_workflow';

export default {
  name: "PersonLiveSchedule",
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
    scheduleWorkflowMixin,
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
        this.get(`/person/${this.selected.id}/live_sessions`).then(data => {
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
        this.getSchedule();
      }
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
