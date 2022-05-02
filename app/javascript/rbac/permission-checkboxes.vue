<template>
  <div>
    <table class="table table-striped">
      <!-- <tr v-for="(perms, policyName) in policies" :key="policyName">
        <td>{{policyName}}</td>
        <td v-for="(dflt, perm) in perms" :key="perm" class="p-2">
          <b-checkbox v-model="model[policyName][perm]">{{perm}}</b-checkbox>
        </td>
      </tr> -->
      <thead>
        <tr>
          <th>Permission</th>
          <th>View</th>
          <th>Create</th>
          <th>Update</th>
          <th>Delete</th>
        </tr>
      </thead>
      <tbody>
        <template v-for="({policies, label}, category) in model">
          <tr :key="category"><td colspan="5"><strong>{{label}}</strong></td></tr>
          <tr v-for="({label, perms}, policy) in policies" :key="policy">
            <td class="pl-5">{{label}}</td>
            <td><b-checkbox v-if="perms.view !== undefined" v-model="model[category].policies[policy].perms.view"></b-checkbox></td>
            <td><b-checkbox v-if="perms.create !== undefined" v-model="model[category].policies[policy].perms.create"></b-checkbox></td>
            <td><b-checkbox v-if="perms.update !== undefined" v-model="model[category].policies[policy].perms.update"></b-checkbox></td>
            <td><b-checkbox v-if="perms.destroy !== undefined" v-model="model[category].policies[policy].perms.destroy"></b-checkbox></td>
          </tr>
        </template>
      </tbody>
    </table>
  </div>
</template>

<script>
import { policies } from './static-permissions';
import { createRbacModel } from './frontend-model';

export default {
  name: "PermissionCheckboxes",
  data: () => ({
    policies,
    model: null
  }),
  mounted() {
    if (this.model === null) {
      this.model = createRbacModel();
    }
  }
}
</script>

<style>
</style>
