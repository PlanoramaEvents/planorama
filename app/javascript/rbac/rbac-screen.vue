<template>
  <div class="scrollable">
    <permission-checkboxes></permission-checkboxes>
  </div>
</template>

<script>
import PermissionCheckboxes from "./permission-checkboxes";


export default {
  name: "RbacScreen",
  components: {
    PermissionCheckboxes
  }
}
</script>

<style>

</style>
