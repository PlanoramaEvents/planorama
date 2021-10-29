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
  </div>
</template>

<script>
import { modelMixin } from '@mixins'
import { getOrderedRelationships } from '../utils/jsonapi_utils'

export default {
  name: 'PeopleAdminTab',
  mixins: [
    modelMixin
  ],
}
</script>

<style>

</style>
