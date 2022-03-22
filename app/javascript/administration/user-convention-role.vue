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
  name: "UserConventionRole",
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
      {text: "Staff", value: "staff"},
      {text: "Participant", value: "participant"}
    ]
  }),
  computed: {
    formId() {
      return `user-role-${this.person.id}`
    },
    roles: {
      get() {
        console.debug("-- person is ", this.person)
        return Object.values(this.person.convention_roles).map(r => r.role) || []
      },
      set(val) {
        let existingroles = Object.values(this.person.convention_roles)
        let newroles = val;
        let rolesForSaving = [];
        for (let role of newroles) {
          let existing = existingroles.find(r => r.role === role);
          if(existing) {
            rolesForSaving.push(this.buildrole(existing));
          } else {
            rolesForSaving.push({role})
          }
        }
        for (let role of existingroles) {
          if(!newroles.includes(role.role)) {
            rolesForSaving.push({...this.buildrole(role), _destroy: 1})
          }
        }

        this.person.convention_roles_attributes = rolesForSaving
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
    buildrole(v) {
      return {
        id: v.id,
        role: v.role
      }
    },
    onSave() {
      const updatedPerson = {
        convention_roles_attributes: this.person.convention_roles_attributes,
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
