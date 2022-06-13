<!--
  This is a derived property selector. It is derived from the following

  Session Assignment
    - visibility (one of public or private)
    - state (one of proposed accepted rejected)
    - session_assignment_role_type (the role)

  This is because Chicon wanted to have one drop down do three things.
  Future versions should allow the acceptance/rejection and assigment of
  role on a session be seperate fields to enter.


  Chicon derived values:

  participant (visible, accepted)
  invisible participant (invisible, accepted)
  Moderator (visible, accepted)
  Reserve (invisible, proposed)

   ==> no role i.e. null
  Not on this panel ==> rejected state (needs a comment?)
 -->
<template>
  <div>
    <b-form-select
      v-model="assignmentState"
      :options="options"
    ></b-form-select>
    <!--
    {{ sessionAssignment.state }}<br />
    {{ sessionAssignment.visibility }}<br />
    {{ sessionAssignment.session_assignment_role_type_id }}<br />
    -->
  </div>
</template>

<script>
import settingsMixin from "@/store/settings.mixin";

export default {
  name: "AssignmentState",
  mixins: [settingsMixin],
  model: {
    prop: 'sessionAssignment'
  },
  props: {
    sessionAssignment: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      options: [
        { value: null, text: 'Unassigned' },
        { value: 'participant', text: 'Participant' },
        { value: 'invisible', text: 'Invisible participant' },
        { value: 'moderator', text: 'Moderator' },
        { value: 'reserved', text: 'Reserved' },
        { value: 'rejected', text: 'NOT ON THIS PANEL' }
      ]
    }
  },
  computed: {
    assignmentState: {
      get() {
        if (this.sessionAssignment.state === 'proposed') return null
        if (this.sessionAssignment.state === 'rejected') return 'rejected'

        if (this.sessionRoleByName('Participant')?.id === this.sessionAssignment.session_assignment_role_type_id) return 'participant'
        if (this.sessionRoleByName('Invisible')?.id === this.sessionAssignment.session_assignment_role_type_id) return 'invisible'
        if (this.sessionRoleByName('Moderator')?.id === this.sessionAssignment.session_assignment_role_type_id) return 'moderator'
        if (this.sessionRoleByName('Reserve')?.id === this.sessionAssignment.session_assignment_role_type_id) return 'reserved'

        return null
      },
      set(val) {
        switch(val) {
          case null:
            // TODO: if this was not an assignment that was marked for interest we will delete it
            this.sessionAssignment.state = 'proposed'
            this.sessionAssignment.visibility = 'is_private'
            this.sessionAssignment.session_assignment_role_type_id = null
            break;
          case 'participant':
            this.sessionAssignment.state = 'accepted'
            this.sessionAssignment.visibility = 'is_public'
            this.sessionAssignment.session_assignment_role_type_id = this.sessionRoleByName('Participant')?.id
            break;
          case 'invisible':
            this.sessionAssignment.state = 'accepted'
            this.sessionAssignment.visibility = 'is_private'
            this.sessionAssignment.session_assignment_role_type_id = this.sessionRoleByName('Invisible')?.id
            break;
          case 'moderator':
            this.sessionAssignment.state = 'accepted'
            this.sessionAssignment.visibility = 'is_public'
            this.sessionAssignment.session_assignment_role_type_id = this.sessionRoleByName('Moderator')?.id
            break;
          case 'reserved':
            this.sessionAssignment.state = 'accepted'
            this.sessionAssignment.visibility = 'is_private'
            this.sessionAssignment.session_assignment_role_type_id = this.sessionRoleByName('Reserve')?.id
            break;
          case 'rejected':
            this.sessionAssignment.state = 'rejected'
            this.sessionAssignment.visibility = 'private'
            this.sessionAssignment.session_assignment_role_type_id = null
            break;
        }
        // emit a change
        this.$emit('input',this.sessionAssignment)
      }
    }
  }
}
</script>

<style>
</style>
