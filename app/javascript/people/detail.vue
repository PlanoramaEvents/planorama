<template>
  <div class="detail">
    <div class="row">
      <div class="col-12">

        <b-button @click="edit" :disabled="editable">Edit</b-button>
        <b-button @click="save" :disabled="!editable">Save</b-button>
        <b-form-group
          label="Name"
        >
          <b-form-input v-model="selected.name" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Name Sort By"
        >
        <b-form-input v-model="selected.name_sort_by" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-checkbox v-model="selected.name_sort_by_confirmed" :disabled="!editable">
          Name Sort By Confirmed
        </b-form-checkbox>

        <b-form-group
          label="Pseudonym"
        >
          <b-form-input v-model="selected.pseudonym" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Pseudonym Sort By"
        >
        <b-form-input v-model="selected.pseudonym_sort_by" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-checkbox v-model="selected.pseudonym_sort_by_confirmed" :disabled="!editable">
          Pseudonym Sort By Confirmed
        </b-form-checkbox>

        <b-form-group
          label="Pronouns"
        >
          <b-form-input v-model="selected.pronouns" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Job Title"
        >
          <b-form-input v-model="selected.job_title" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Organization"
        >
          <b-form-input v-model="selected.organization" :disabled="!editable"></b-form-input>
        </b-form-group>

        <b-form-checkbox v-model="selected.registered" :disabled="!editable">
          Registered
        </b-form-checkbox>

        <b-form-group
          label="Registration Type"
        >
          <b-form-input v-model="selected.registration_type" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Registration Number"
        >
          <b-form-input v-model="selected.registration_number" :disabled="!editable"></b-form-input>
        </b-form-group>

        <b-form-checkbox v-model="selected.opted_in" :disabled="!editable">
          Opted In
        </b-form-checkbox>
        <b-form-checkbox v-model="selected.can_share" :disabled="!editable">
          Can Share
        </b-form-checkbox>
        <b-form-checkbox v-model="selected.can_photo" :disabled="!editable">
          Can Photo
        </b-form-checkbox>
        <b-form-checkbox v-model="selected.can_record" :disabled="!editable">
          Can Record
        </b-form-checkbox>

        <b-form-group
          label="Gender"
        >
          <b-form-input v-model="selected.gender" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Ethnicity"
        >
          <b-form-input v-model="selected.ethnicity" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Year of Birth"
        >
          <!-- TODO: year selector/number -->
          <b-form-input
            v-model="selected.year_of_birth"
            :disabled="!editable"></b-form-input>
        </b-form-group>

        <b-form-group
          label="Comments"
        >
          <b-form-textarea v-model="selected.comments" :disabled="!editable"></b-form-textarea>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';

export default {
  name: "Detail",
  mixins: [
    modelMixin
  ],
  data: () => ({
    editable: false,
  }),
  methods: {
    edit() {
      this.editable = true
    },
    save() {
      this.editable = false
      this.$store.dispatch('jv/update', this.selected).then((data) => {
        // How do we get this to update the model in the store ????
        console.log('saved: ', data.id)
      })
    }
  }
}
</script>

<style>

</style>
