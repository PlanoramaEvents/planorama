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
      return this.collection.filter(sa => sa.session_assignment_role_type_id === this.sessionRole?.id);
    }
  },
}
</script>

<style>

</style>
