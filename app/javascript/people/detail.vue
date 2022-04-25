<template>
  <div class="detail">
    <div class="row">
      <div class="col-12">
        <div>
          <label>Name:</label>
          {{ selected.name }}
        </div>
        <div>
          <label>Name Sort By:</label>
          {{ selected.name_sort_by }}
        </div>
        <div>
          <label>Name Sort By Confirmed:</label>
          {{ selected.name_sort_by_confirmed }}
        </div>
        <div>
          <label>Pseudonym:</label>
          {{ selected.pseudonym }}
        </div>
        <div>
          <label>Pseudonym Sort By:</label>
          {{ selected.pseudonym_sort_by }}
        </div>
        <div>
          <label>Pseudonym Sort By Confirmed:</label>
          {{ selected.pseudonym_sort_by_confirmed }}
        </div>
        <div>
          <label>Bio:</label>
          {{ selected.bio }}
        </div>
        <div>
          <label>Pronouns:</label>
          {{ selected.pronouns }}
        </div>
        <div>
          <label>Job Title:</label>
          {{ selected.job_title }}
        </div>
        <div>
          <label>Organization:</label>
          {{ selected.organization }}
        </div>
        <div>
          <label>Registered:</label>
          {{ selected.registered ? 'Y' : 'N' }}
        </div>
        <div>
          <label>Registration Type:</label>
          {{ selected.registration_type }}
        </div>
        <div>
          <label>Registration Number:</label>
          {{ selected.registration_number }}
        </div>
        <div>
          <label>Opted In:</label>
          {{ selected.opted_in }}
        </div>
        <div>
          <label>Can Share:</label>
          {{ selected.can_share ? 'Y' : 'N' }}
        </div>
        <div>
          <label>Can Photo:</label>
          {{ selected.can_photo ? 'Y' : 'N' }}
        </div>
        <div>
          <label>Can Stream:</label>
          {{ selected.can_stream ? 'Y' : 'N' }}
        </div>
        <div>
          <label>Can Record:</label>
          {{ selected.can_record ? 'Y' : 'N' }}
        </div>
        <div>
          <label>Gender:</label>
          {{ selected.gender }}
        </div>
        <div>
          <label>Ethnicity:</label>
          {{ selected.ethnicity }}
        </div>
        <div>
          <label>Year of Birth:</label>
          {{ selected.year_of_birth }}
        </div>
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
  }
}
</script>

<style>

</style>
