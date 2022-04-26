<template>
  <div class="detail">
    <dl class="row">
      <dt class="col-sm-4">Name:</dt>
      <dd class="col-sm-8">{{ selected.name }}</dd>
      <dt class="col-sm-4">Name Sort By:</dt>
      <dd class="col-sm-8">{{ selected.name_sort_by }}</dd>
      <dt class="col-sm-4">Name Sort By Confirmed:</dt>
      <dd class="col-sm-8">{{ selected.name_sort_by_confirmed ? 'Y' : 'N' }}</dd>
      <dt class="col-sm-4">Pseudonym:</dt>
      <dd class="col-sm-8">{{ selected.pseudonym }}</dd>
      <dt class="col-sm-4">Pseudonym Sort By:</dt>
      <dd class="col-sm-8">{{ selected.pseudonym_sort_by }}</dd>
      <dt class="col-sm-4">Pseudonym Sort By Confirmed:</dt>
      <dd class="col-sm-8">{{ selected.pseudonym_sort_by_confirmed ? 'Y' : 'N' }}</dd>
      <dt class="col-sm-12">Bio:</dt>
      <dd class="col-sm-11 offset-sm-1">{{ selected.bio }}</dd>
      <dt class="col-sm-4">Pronouns:</dt>
      <dd class="col-sm-8">{{ selected.pronouns }}</dd>
      <dt class="col-sm-4">Job Title:</dt>
      <dd class="col-sm-8">{{ selected.job_title }}</dd>
      <dt class="col-sm-4">Organization:</dt>
      <dd class="col-sm-8">{{ selected.organization }}</dd>
      <dt class="col-sm-4">Registered:</dt>
      <dd class="col-sm-8">{{ selected.registered ? 'Y' : 'N' }}</dd>
      <dt class="col-sm-4">Opted In:</dt>
      <dd class="col-sm-8">{{ selected.opted_in }}</dd>
      <dt class="col-sm-4">Can Share:</dt>
      <dd class="col-sm-8">{{ selected.can_share ? 'Y' : 'N' }}</dd>
      <dt class="col-sm-4">Can Photo:</dt>
      <dd class="col-sm-8">{{ selected.can_photo ? 'Y' : 'N' }}</dd>
      <dt class="col-sm-4">Can Stream:</dt>
      <dd class="col-sm-8">{{ selected.can_stream ? 'Y' : 'N' }}</dd>
      <dt class="col-sm-4">Can Record:</dt>
      <dd class="col-sm-8">{{ selected.can_stream ? 'Y' : 'N' }}</dd>
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
