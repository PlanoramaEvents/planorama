<template>
  <b-form-group :label="person.name" label-cols="4" :label-for="formId">
    <b-form-checkbox-group :id="formId" :name="formId" inline v-model="roles" :options="roleOptions" @change="save">
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
      {text: "Admin",  value: "admin"},
      {text: "Staff", value: "planner"},
      {text: "Participant", value: "member"}
    ]
  }),
  computed: {
    formId() {
      return `user-role-${this.person.id}`
    },
    roles: {
      get() {
        return this.person.$.person_roles?.map(r => r.role) || [];
      },
      set(val) {
        let existingRoles = this.person.person_roles;
        let newRoles = val;
        let rolesForSaving = [];
        for (let role of newRoles) {
          let existing = existingRoles.find(r => r.role === role);
          if(existing) {
            rolesForSaving.push(existing);
          } else {
            rolesForSaving.push({role})
          }
        }
        for (let role of existingRoles) {
          if(!newRoles.includes(role.role)) {
            rolesForSaving.push({...role, _destroy: 1})
          }
        }
        this.person.person_roles = rolesForSaving;
        console.log(this.person.person_roles)
      }
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
