<template>
  <div class="detail">
    <div class="row">
      <div class="col-12">

        <b-button @click="edit" :disabled="editable">Edit</b-button>
        <b-button @click="save" :disabled="!editable">Save</b-button>
        <b-form-group
          label="Name"
        >
          <b-form-input v-model="person.name" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Name Sort By"
        >
        <b-form-input v-model="person.name_sort_by" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-checkbox v-model="person.name_sort_by_confirmed" :disabled="!editable">
          Name Sort By Confirmed
        </b-form-checkbox>

        <b-form-group
          label="Pseudonym"
        >
          <b-form-input v-model="person.pseudonym" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-group
          label="Pseudonym Sort By"
        >
        <b-form-input v-model="person.pseudonym_sort_by" :disabled="!editable"></b-form-input>
        </b-form-group>
        <b-form-checkbox v-model="person.pseudonym_sort_by_confirmed" :disabled="!editable">
          Pseudonym Sort By Confirmed
        </b-form-checkbox>

        <!--
        pronouns
        job title
        organization
        registered
        reg type
        reg number
        opt in
        can share
        can photo
        can record
        gender
        ethnicity
        year of birth
        comments
        -->
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: "Detail",
  props: {
    person: {
      type: Object
    }
  },
  data: () => ({
    editable: false,
  }),
  methods: {
    edit() {
      this.editable = true
    },
    save() {
      // this.editable = true
      this.editable = false
      console.debug('******** SAVE PERSON ????', this.person)
      // this.person.save()
      this.$store.dispatch('jv/update', this.person).then((data) => {
        console.log(data)
      })
    }
  }
}
</script>

<style>

</style>
