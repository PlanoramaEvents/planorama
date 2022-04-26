<template>
  <div>
    <dl class="row">
      <dt class="col-sm-4">Convention Class:</dt>
      <dd class="col-sm-8">
        <span v-for="role of selected.convention_roles" :key="role.id">
          {{ role.role }}
        </span>
      </dd>
      <dt class="col-sm-12">Comments:</dt>
      <dd class="col-sm-12">
        <b-form-textarea v-model="comments"></b-form-textarea>
        <b-button class="float-right mt-1" @click="patchSelected({comments})" variant="primary">Save Comments</b-button>
      </dd>
    </dl>
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
