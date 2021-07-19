<template>
  <b-form-group :label="person.name" label-cols="4" :label-for="formId">
    <b-form-checkbox-group :id="formId" inline v-model="person.person_roles" :options="roleOptions" @change="save">
    </b-form-checkbox-group>
  </b-form-group>
</template>

<script>
import toastMixin from '../toast-mixin'
export default {
  name: "UserRole",
  mixins: [toastMixin],
  props: {
    person: {
      required: true
    }
  },
  data: () => ({
    roleOptions: [
      {text: "Admin", value: {role: "admin"}},
      {text: "Staff", value: {role: "planner"}},
      {text: "Participant", value: {role: "member"}}
    ]
  }),
  computed: {
    formId() {
      return `user-role-${this.person.id}`
    }
  },
  methods: {
    save() {
      this.toastCallback(this.person.save, "User successfully saved");
    }
  }
}
</script>

<style>

</style>
