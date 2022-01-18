<template>
  <div v-if="person">
    <b-form-group :label="person.name" label-cols="4" :label-for="formId">
      <b-form-checkbox-group :id="formId" :name="formId" inline v-model="roles" :options="roleOptions" @change="onSave">
      </b-form-checkbox-group>
    </b-form-group>
  </div>
</template>

<script>
import toastMixin from '../shared/toast-mixin'
import modelMixin from '../store/model.mixin'

export default {
  name: "UserRole",
  mixins: [
    modelMixin,
    toastMixin
  ],
  props: {
    personId: {
      required: true
    }
  },
  data: () => ({
    person: null,
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
        return Object.values(this.person.person_roles).map(r => r.role) || []
      },
      set(val) {
        let existingRoles = Object.values(this.person.person_roles)
        let newRoles = val;
        let rolesForSaving = [];
        for (let role of newRoles) {
          let existing = existingRoles.find(r => r.role === role);
          if(existing) {
            rolesForSaving.push(this.buildRole(existing));
          } else {
            rolesForSaving.push({role})
          }
        }
        for (let role of existingRoles) {
          if(!newRoles.includes(role.role)) {
            rolesForSaving.push({...this.buildRole(role), _destroy: 1})
          }
        }

        this.person.person_roles_attributes = rolesForSaving
      }
    }
  },
  watch: {
    personId(newVal, oldVal) {
      if (newVal) {
        this.init()
      }
    }
  },
  methods: {
    buildRole(v) {
      return {
        id: v.id,
        role: v.role
      }
    },
    onSave() {
      const updatedPerson = {
        person_roles_attributes: this.person.person_roles_attributes,
        _jv: {
          type: 'person',
          id: this.person.id
        },
      }

      this.save(updatedPerson).then(
        (data) => {
          // TODO: this mutation is a problem, so how do we update the person
          this.person = data
        }
      )
    },
    init() {
      if (this.personId == null) {
        this.person = null
        return
      }

      this.loading = true
      this.fetch_by_id(
        this.personId
      ).then(data => {
        this.person = data
        this.loading = false
      })
    }
  },
  mounted() {
    this.init()
  }
}
</script>

<style>

</style>
