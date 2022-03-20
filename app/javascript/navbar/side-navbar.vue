<template>
  <div id="side-navbar" class="col-12 col-sm-3 col-xl-2 pl-0">
    <b-nav vertical>
      <b-nav-item to="/dashboard" active-class="active"><b-icon-pie-chart-fill class="mr-2"></b-icon-pie-chart-fill>Dashboard</b-nav-item>
      <b-nav-item to="/venues" active-class="active"><b-icon-building class="mr-2"></b-icon-building>Venues</b-nav-item>
      <b-nav-item to="/people" active-class="active"><b-icon-person-fill class="mr-2"></b-icon-person-fill>People</b-nav-item>
      <!-- <b-nav-item v-b-toggle.collapse-mailing variant="primary"><b-icon-envelope-fill class="mr-2"></b-icon-envelope-fill>Communications</b-nav-item>
      <b-collapse id="collapse-mailing" class="mt-2">
        <b-nav-item to="/mailing" active-class="active"><b-icon-mailbox class="mr-2"></b-icon-mailbox>Mailing</b-nav-item>
        <b-nav-item to="/mail-templates" active-class="active"><b-icon-card-text class="mr-2"></b-icon-card-text>Templates</b-nav-item>
      </b-collapse> -->
      <b-nav-item to="/schedule" active-class="active"><b-icon-calendar2-range-fill class="mr-2"></b-icon-calendar2-range-fill>Schedule</b-nav-item>
      <b-nav-item to="/surveys" active-class="active"><icon-survey class="mr-2"></icon-survey>Surveys</b-nav-item>
      <b-nav-item to="/reports" active-class="active"><b-icon-bar-chart-line-fill class="mr-2"></b-icon-bar-chart-line-fill>Reports</b-nav-item>
      <b-nav-item to="/profile" active-class="active"><b-icon-person-badge class="mr-2"></b-icon-person-badge>Profile</b-nav-item>
      <b-nav-item to="/admin" active-class="active"><b-icon-person-badge class="mr-2"></b-icon-person-badge>Admin</b-nav-item>
    </b-nav>
  </div>
</template>

<script>
import personSessionMixin from '../auth/person_session.mixin.js';
export default {
  name: 'SideNavbar',
  mixins: [personSessionMixin],
}
</script>

<style>

</style>
