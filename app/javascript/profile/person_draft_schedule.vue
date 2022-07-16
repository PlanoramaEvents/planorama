<template>
  <person-schedule-display :sessions="sessions" title="Draft Schedule" approvalType="draft"></person-schedule-display>
</template>

<script>
import { mapActions } from 'vuex';
import PersonScheduleDisplay from './person_schedule_display.vue';
import { personModel as model } from '@/store/person.store';
import { modelMixinNoProp } from '@/mixins';

export default {
  name: "PersonDraftSchedule",
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
  },
  mounted() {
    if(this.selected) {
      this.get(`/person/${this.selected.id}/snapshot_schedule`).then(data => {
        const {_jv, ...filtered_data} = data;
        this.sessions = filtered_data;
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.larger-text {
  font-size: 16px;
}

.indented-dl {
  dd {
    margin-left: 0.5rem;
    &:not(.not-italic) {
      font-style: italic;
    }
  }
}
</style>
