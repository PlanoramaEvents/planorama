import { settingsMixin } from "@/mixins";

export const sessionRoleMixin = {
  mixins: [ settingsMixin ],
  computed: {
    moderatorRole() {
      return this.sessionRoleByName('Moderator');
    },
    participantRole() {
      return this.sessionRoleByName('Participant');
    },
    invisibleRole() {
      return this.sessionRoleByName('Invisible');
    },
    reserveRole() {
      return this.sessionRoleByName('Reserve');
    }
  },
  methods: {
    isModerator(sa) {
      return sa.session_assignment_role_type_id && sa.session_assignment_role_type_id === this.moderatorRole?.id
    },
    isParticipant(sa) {
      return sa.session_assignment_role_type_id && sa.session_assignment_role_type_id === this.participantRole?.id
    },
    isInvisible(sa) {
      return sa.session_assignment_role_type_id && sa.session_assignment_role_type_id === this.invisibleRole?.id
    },
    isReserve(sa) {
      return sa.session_assignment_role_type_id && sa.session_assignment_role_type_id === this.reserveRole?.id
    },
  }
}

export default sessionRoleMixin;
