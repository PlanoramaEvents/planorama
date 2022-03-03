<template>
  <div v-if="person">
    <b-form-group :label="person.name" label-cols="4" :label-for="formId">
      <b-form-checkbox-group :id="formId" :name="formId" inline v-model="groups" :options="groupOptions" @change="onSave">
      </b-form-checkbox-group>
    </b-form-group>
  </div>
</template>

<script>
import toastMixin from '../shared/toast-mixin'
import modelMixin from '../store/model.mixin'

export default {
  name: "Usergroup",
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
    groupOptions: [
      {text: "Admin",  value: "admin"},
      {text: "Staff", value: "staff"},
      {text: "Participant", value: "participant"}
    ]
  }),
  computed: {
    formId() {
      return `user-group-${this.person.id}`
    },
    groups: {
      get() {
        return Object.values(this.person.person_groups).map(r => r.group) || []
      },
      set(val) {
        let existinggroups = Object.values(this.person.person_groups)
        let newgroups = val;
        let groupsForSaving = [];
        for (let group of newgroups) {
          let existing = existinggroups.find(r => r.group === group);
          if(existing) {
            groupsForSaving.push(this.buildgroup(existing));
          } else {
            groupsForSaving.push({group})
          }
        }
        for (let group of existinggroups) {
          if(!newgroups.includes(group.group)) {
            groupsForSaving.push({...this.buildgroup(group), _destroy: 1})
          }
        }

        this.person.person_groups_attributes = groupsForSaving
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
    buildgroup(v) {
      return {
        id: v.id,
        group: v.group
      }
    },
    onSave() {
      const updatedPerson = {
        person_groups_attributes: this.person.person_groups_attributes,
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
