<template>
  <div>
    <dt>{{sessionRoleLabel || sessionRoleName}}</dt>
    <dd v-if="!myAssignments.length" class="text-muted font-italic ml-2">None Assigned</dd>
    <dd v-for="{person} in myAssignments" :key="person.id" class="ml-2"><router-link :to="'/people/edit/' + person.id">{{person.published_name}}</router-link></dd>
  </div>
</template>

<script>
import { modelMixinNoProp } from '@/store/model.mixin'
import { sessionAssignmentModel as model} from '@/store/session_assignment.store'
import settingsMixin from '@/store/settings.mixin'
export default {
  name: "ViewParticipantType",
  props: {
    session: {
      required: true
    },
    sessionRoleName: {
      required: true
    },
    sessionRoleLabel: {
      required: false
    }
  },
  mixins: [
    modelMixinNoProp,
    settingsMixin
  ],
  data: () => ({
    model
  }),
  computed: {
    sessionRole() {
      return this.sessionRoleByName(this.sessionRoleName);
    },
    myAssignments() {
      // Using the fetch collection instead of relationship now
      const coll = this.collection.filter(
        sa => (sa.session_assignment_role_type_id === this.sessionRole?.id && sa.session_id === this.session.id)
      );
      coll.sort((a, b) => a.published_name < b.published_name ? -1 : a.published_name > b.published_name ? 1 : 0)
      return coll;
    }
  }
}
</script>

<style>

</style>
