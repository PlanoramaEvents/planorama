<template>
  <div id="side-navbar" class="col-12 col-sm-3 col-xl-2">
    <b-nav vertical>
      <b-nav-item to="/" active-class="active"><b-icon-pie-chart-fill class="mr-2"></b-icon-pie-chart-fill>Dashboard</b-nav-item>
      <b-nav-item to="/venues" active-class="active"><b-icon-building class="mr-2"></b-icon-building>Venues</b-nav-item>
      <b-nav-item to="/people" active-class="active"><b-icon-person-fill class="mr-2"></b-icon-person-fill>People</b-nav-item>
      <b-nav-item to="/program" active-class="active"><b-icon-calendar2-range-fill class="mr-2"></b-icon-calendar2-range-fill>Schedule</b-nav-item>
      <b-nav-item to="/surveys" active-class="active"><icon-survey class="mr-2"></icon-survey>Surveys</b-nav-item>
      <b-nav-item to="/reports" active-class="active"><b-icon-bar-chart-line-fill class="mr-2"></b-icon-bar-chart-line-fill>Reports</b-nav-item>
      <b-nav-item to="/admin" active-class="active"><b-icon-person-badge class="mr-2"></b-icon-person-badge>Admin</b-nav-item>
    </b-nav>
  </div>
</template>

<script>
export default {
  name: 'SideNavbar'
}
</script>

<style>

</style>
