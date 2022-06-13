<template>
  <div>
    <view-participant-type :session="session" sessionRoleName="Moderator"></view-participant-type>
    <view-participant-type :session="session" sessionRoleName="Participant"></view-participant-type>
    <view-participant-type :session="session" sessionRoleName="Invisible" sessionRoleLabel="Invisible Participant"></view-participant-type>
    <view-participant-type :session="session" sessionRoleName="Reserve" sessionRoleLabel="Reserved"></view-participant-type>
  </div>
</template>

<script>
import { modelMixinNoProp } from '@/store/model.mixin'
import { sessionAssignmentModel as model} from '@/store/session_assignment.store'
import ViewParticipantType from './view_participant_type.vue';

export default {
  name: "ViewParticipants",
  components: {
    ViewParticipantType,
  },
  props: {
    session: {
      required: true
    },
  },
  mixins: [
    modelMixinNoProp,
  ],
  data: () => ({
    model
  }),
  watch: {
    session(newSession, oldSession) {
      if (newSession) {
        if ((oldSession && oldSession.id !== newSession.id) || !oldSession) {
          this.clear();
          this.fetch({session_id: this.session.id})
        }
      }
    }
  },
  mounted() {
    this.clear();
    this.fetch({session_id: this.session.id})
  }
}
</script>

<style>

</style>
