<template>
  <div class="row">
    <div class="col-12">
      Hello {{currentUser.name}}!
    </div>
  </div>
</template>

<script>
import { modelStore } from '../store/model.store';
import sessionMixin from '../session/session.mixin';

export default {
  name: "Dashboard",
  store: modelStore,
  mixins: [sessionMixin]
}
</script>

<style>

</style>
