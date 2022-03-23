<template>
  <div>
    <div class="mb-3">
      Availbility and Interests
    </div>
    <availability-calendar></availability-calendar>
  </div>
</template>

<script>
import AvailabilityCalendar from './availability_calendar.vue';
// import PeopleSidebar from './people_sidebar.vue';
// import { personModel as model } from '../store/person.store';

export default {
  name: "AvailabilityAndInterests",
  data: () => ({
    // model
  }),
  components: {
    AvailabilityCalendar
    // PeopleSidebar,
  }
}
</script>

<style>

</style>
