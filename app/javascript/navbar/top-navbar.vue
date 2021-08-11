<template>
  <div class="col-12">
    <b-navbar toggleable="lg" type="light" class="align-items-baseline">
      <b-navbar-brand to="/">Planorama</b-navbar-brand>
      <b-navbar-nav class="ml-auto">
        <b-nav-form>
          <help-link></help-link>
          <a href="https://chicagoworldcon.github.io/planorama" target="_blank" class="btn btn-link text-light my-2 my-sm-0 mx-2">About</a>
          <!-- TODO logout button -->
        </b-nav-form>
      </b-navbar-nav>
    </b-navbar>
    <!-- TODO fix toaster -->
    <b-toaster id="planotoast" name="planotoast"></b-toaster>
  </div>
</template>

<script>
import HelpLink from '../administration/help_link.vue';

export default {
  name: 'TopNavbar',
  components: {
    HelpLink,
  }
}
</script>

<style>

</style>
