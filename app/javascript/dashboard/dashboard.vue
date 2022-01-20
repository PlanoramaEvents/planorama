<template>
  <div class="row">
    <div class="col-12">
      Hello {{currentUser.name}}!
    </div>
  </div>
</template>

<script>
import personsessionMixin from '../auth/person_session.mixin';

export default {
  name: "Dashboard",
  mixins: [personsessionMixin]
}
</script>

<style>

</style>
