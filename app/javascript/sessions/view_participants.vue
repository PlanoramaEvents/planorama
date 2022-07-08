<template>
  <div>
    <b-skeleton-wrapper :loading="loading">
      <template #loading>
        <dd>Moderator</dd>
        <dt class="ml-2"><b-skeleton width="10rem"></b-skeleton></dt>
        <dd>Participant</dd>
        <dt class="ml-2"><b-skeleton width="10rem"></b-skeleton></dt>
        <dd>Invisible Participant</dd>
        <dt class="ml-2"><b-skeleton width="10rem"></b-skeleton></dt>
        <dd>Reserved</dd>
        <dt class="ml-2"><b-skeleton width="10rem"></b-skeleton></dt>
      </template>
      <view-participant-type :session="session" sessionRoleName="Moderator"></view-participant-type>
      <view-participant-type :session="session" sessionRoleName="Participant"></view-participant-type>
      <view-participant-type :session="session" sessionRoleName="Invisible" sessionRoleLabel="Invisible Participant"></view-participant-type>
      <view-participant-type :session="session" sessionRoleName="Reserve" sessionRoleLabel="Reserved"></view-participant-type>
    </b-skeleton-wrapper>
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
    model,
    loading: false
  }),
  methods: {
    load() {
      this.clear();
      this.loading = true;
      this.fetch({session_id: this.session.id}).then(() => {
        this.loading = false;
      })
    }
  },
  watch: {
    session(newSession, oldSession) {
      if (newSession) {
        if ((oldSession && oldSession.id !== newSession.id) || !oldSession) {
          this.load();
        }
      }
    }
  },
  mounted() {
    this.load();
  }
}
</script>

<style>

</style>
