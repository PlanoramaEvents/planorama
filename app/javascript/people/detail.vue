<template>
  <div class="detail">
    <dl>
      <dt>Name:</dt>
      <dd class="ml-2">{{ selected.name }}</dd>
      <dt>Name Sort By:</dt>
      <dd class="ml-2">{{ selected.name_sort_by | na_if_empty}}</dd>
      <dt>Name Sort By Confirmed:</dt>
      <dd class="ml-2">{{ selected.name_sort_by_confirmed ? 'Y' : 'N' }}</dd>
      <dt>Pseudonym:</dt>
      <dd class="ml-2">{{ selected.pseudonym | na_if_empty}}</dd>
      <dt>Pseudonym Sort By:</dt>
      <dd class="ml-2">{{ selected.pseudonym_sort_by | na_if_empty}}</dd>
      <dt>Pseudonym Sort By Confirmed:</dt>
      <dd class="ml-2">{{ selected.pseudonym_sort_by_confirmed ? 'Y' : 'N' }}</dd>
      <dt>Bio:</dt>
      <dd class="ml-2">
        <span v-html="selected.bio" v-if="selected.bio"></span>
        <span v-else>N/A</span>
      </dd>
      <dt>Pronouns:</dt>
      <dd class="ml-2">{{ selected.pronouns | na_if_empty}}</dd>
      <dt>Job Title:</dt>
      <dd class="ml-2">{{ selected.job_title | na_if_empty}}</dd>
      <dt>Organization:</dt>
      <dd class="ml-2">{{ selected.organization | na_if_empty}}</dd>
      <dt>Registered:</dt>
      <dd class="ml-2">{{ selected.registered ? 'Y' : 'N' }}</dd>
      <dt>Opted In:</dt>
      <dd class="ml-2">{{ selected.opted_in ? 'Y' : 'N'}}</dd>
      <dt>Can Share:</dt>
      <dd class="ml-2">{{ selected.can_share ? 'Y' : 'N' }}</dd>
      <dt>Can Photo:</dt>
      <dd class="ml-2">{{ selected.can_photo === "yes" ? 'Y' : 'N' }}</dd>
      <dt>Can Stream:</dt>
      <dd class="ml-2">{{ selected.can_stream === "yes" ? 'Y' : 'N' }}</dd>
      <dt>Can Record:</dt>
      <dd class="ml-2">{{ selected.can_record === "yes" ? 'Y' : 'N' }}</dd>
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
