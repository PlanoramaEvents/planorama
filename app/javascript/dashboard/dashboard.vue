<template>
  <div class="row">
    <div class="col-12">
      Hello {{currentUser.name}}!
    </div>
  </div>
</template>

<script>
import sessionMixin from '../session/session.mixin';

export default {
  name: "Dashboard",
  mixins: [sessionMixin]
}
</script>

<style>

</style>
