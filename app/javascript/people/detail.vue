<template>
  <div class="detail">
    <dl>
      <dt>Name:</dt>
      <dd>{{ selected.name }}</dd>
      <dt>Name Sort By:</dt>
      <dd>{{ selected.name_sort_by }}</dd>
      <dt>Name Sort By Confirmed:</dt>
      <dd>{{ selected.name_sort_by_confirmed }}</dd>

      <dt>Pseudonym:</dt>
      <dd>{{ selected.pseudonym }}</dd>
      <dt>Pseudonym Sort By:</dt>
      <dd>{{ selected.pseudonym_sort_by }}</dd>
      <dt>Pseudonym Sort By Confirmed:</dt>
      <dd>{{ selected.pseudonym_sort_by_confirmed }}</dd>

      <dt>Bio:</dt>
      <dd>{{ selected.bio }}</dd>

      <dt>Pronouns:</dt>
      <dd>{{ selected.pronouns }}</dd>
      <dt>Job Title:</dt>
      <dd>{{ selected.job_title }}</dd>

      <dt>Organization:</dt>
      <dd>{{ selected.organization }}</dd>

      <dt>Registered:</dt>
      <dd>{{ selected.registered ? 'Y' : 'N' }}</dd>

      <dt>Registration Type:</dt>
      <dd>{{ selected.registration_type }}</dd>
      <dt>Registration Number:</dt>
      <dd>{{ selected.registration_number }}</dd>

      <dt>Opted In:</dt>
      <dd>{{ selected.opted_in }}</dd>
      <dt>Can Share:</dt>
      <dd>{{ selected.can_share ? 'Y' : 'N' }}</dd>
      <dt>Can Photo:</dt>
      <dd>{{ selected.can_photo ? 'Y' : 'N' }}</dd>
      <dt>Can Stream:</dt>
      <dd>{{ selected.can_stream ? 'Y' : 'N' }}</dd>
      <dt>Can Record:</dt>
      <dd>{{ selected.can_stream ? 'Y' : 'N' }}</dd>

      <dt>Gender:</dt>
      <dd>{{ selected.gender }}</dd>
      <dt>Ethnicity:</dt>
      <dd>{{ selected.ethnicity }}</dd>
      <dt>Year of Birth:</dt>
      <dd>{{ selected.year_of_birth }}</dd>
    </dl>
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
