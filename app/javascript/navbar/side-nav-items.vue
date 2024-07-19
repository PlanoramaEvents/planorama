<template>
  <div>
    <b-nav-item to="/dashboard" active-class="active"
      ><b-icon-pie-chart-fill class="mr-2"></b-icon-pie-chart-fill
      >Dashboard</b-nav-item
    >
    <!-- <b-nav-item v-if="can_see_this" to="/venues" active-class="active"><b-icon-building class="mr-2"></b-icon-building>Venues</b-nav-item> -->
    <b-nav-item v-if="can_see_this" to="/people" active-class="active"
      ><b-icon-person-fill class="mr-2"></b-icon-person-fill>People</b-nav-item
    >
    <!-- <b-nav-item v-b-toggle.collapse-mailing variant="primary"><b-icon-envelope-fill class="mr-2"></b-icon-envelope-fill>Communications</b-nav-item>
      <b-collapse id="collapse-mailing" class="mt-2">
        <b-nav-item to="/mailing" active-class="active"><b-icon-mailbox class="mr-2"></b-icon-mailbox>Mailing</b-nav-item>
        <b-nav-item to="/mail-templates" active-class="active"><b-icon-card-text class="mr-2"></b-icon-card-text>Templates</b-nav-item>
      </b-collapse> -->
    <b-nav-item v-if="can_see_this" to="/sessions" active-class="active"
      ><b-icon-calendar2-range-fill class="mr-2"></b-icon-calendar2-range-fill
      >Sessions</b-nav-item
    >
    <b-nav-item v-if="can_see_this" to="/schedule" active-class="active"
      ><b-icon-calendar2-date class="mr-2"></b-icon-calendar2-date
      >Schedule</b-nav-item
    >
    <b-nav-item v-if="can_see_this" to="/surveys" active-class="active"
      ><icon-survey class="mr-2"></icon-survey>Surveys</b-nav-item
    >
    <b-nav-item v-if="can_see_this" to="/reports" active-class="active"
      ><b-icon-bar-chart-line-fill class="mr-2"></b-icon-bar-chart-line-fill
      >Reports</b-nav-item
    >
    <b-nav-item to="/profile" active-class="active"
      ><b-icon-person-badge class="mr-2"></b-icon-person-badge
      >Profile</b-nav-item
    >
    <b-nav-item v-if="currentUserIsAdmin" to="/admin" active-class="active"
      ><b-icon-minecart-loaded class="mr-2"></b-icon-minecart-loaded
      >Admin</b-nav-item
    >
    <b-nav-item
      v-if="currentUserIsAdmin"
      to="/admin-configurations"
      active-class="active"
      ><b-icon-minecart-loaded class="mr-2"></b-icon-minecart-loaded
      >Configurations</b-nav-item
    >
    <!-- <b-nav-item v-if="currentUserIsAdmin" to="/admin-registrations" active-class="active"><b-icon-minecart-loaded class="mr-2"></b-icon-minecart-loaded>Registrations</b-nav-item> -->
  </div>
</template>

<script>
import personSessionMixin from "../auth/person_session.mixin.js";

export default {
  name: "SideNavItems",
  mixins: [personSessionMixin],
  computed: {
    can_see_this() {
      return this.currentUserIsAdmin || this.currentUserIsStaff;
    },
  },
};
</script>

<style></style>
