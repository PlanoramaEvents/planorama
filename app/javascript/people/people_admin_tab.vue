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
import { modelMixin } from '@mixins'

export default {
  name: 'PeopleAdminTab',
  mixins: [
    modelMixin
  ],
  data: () => ({
    comments: ""
  }),
  mounted() {
    if(this.selected) {
      this.comments = this.selected.comments;
    }
  },
  watch: {
    selected(newVal, oldVal) {
      if(newVal && (!oldVal || oldVal.comments !== newVal.comments)) {
        this.comments = newVal.comments;
      }
    }
  }
}
</script>

<style>

</style>
