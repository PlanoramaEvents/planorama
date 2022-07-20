<template>
  <person-schedule-display :sessions="sessions" :title="liveScheduleTitle" :approvalType="firmSchedule ? 'firm' : null"></person-schedule-display>
</template>

<script>
import { mapActions } from 'vuex';
import PersonScheduleDisplay from './person_schedule_display.vue';
import { personModel as model } from '@/store/person.store';
import { modelMixinNoProp } from '@/mixins';
import { scheduleStatusMixin } from '@/store/schedule_status.mixin';

export default {
  name: "PersonLiveSchedule",
  components: {
    PersonScheduleDisplay
  },
  mixins: [
    modelMixinNoProp,
    scheduleStatusMixin,
  ],
  data: () => ({
    sessions: {},
    model,
  }),
  methods: {
    ...mapActions({
      get: 'jv/get'
    }),
  },
  mounted() {
    if(this.selected) {
      this.get(`/person/${this.selected.id}/live_sessions`).then(data => {
        const {_jv, ...filtered_data} = data;
        this.sessions = filtered_data;
      })
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
