<template>
  <div>
    <h2>Roles</h2>
    <ul>
      <li v-for="role of selected.person_roles" :key="role.id">
        {{ role.role }}
      </li>
    </ul>
    <h2>Mail History</h2>
    <pre>{{ selected.mail_histories }}</pre>
    <h2>Comments</h2> 
    <b-form-textarea v-model="comments"></b-form-textarea>
    <b-button class="float-right" @click="patchSelected({comments})" variant="primary">Save Comments</b-button>
  </div>
</template>

<script>
import { modelMixin, makeSelectedFieldMixin } from '@/mixins'
const commentsMixin = makeSelectedFieldMixin('comments');

export default {
  name: 'PeopleAdminTab',
  mixins: [
    modelMixin,
    commentsMixin
  ]
}
</script>

<style>

</style>
