<template>
  <div id="side-navbar" class="col-12 col-sm-2 col-xl-2 pl-0">
    <b-nav vertical>
      <side-nav-items></side-nav-items>
    </b-nav>
  </div>
</template>

<script>
import SideNavItems from './side-nav-items.vue';

export default {
  name: 'SideNavbar',
  components: {
    SideNavItems,
  }
}
</script>

<style lang="scss" scoped>
@media (max-width: 575px) {
  #side-navbar {
    display: none !important;
  }
}
</style>
