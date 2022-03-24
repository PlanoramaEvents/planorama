<template>
  <div>
    <div class="mb-3">
      Availbility and Interests
    </div>
    <availability-calendar
      :days="days"
    ></availability-calendar>
  </div>
</template>

<script>
import AvailabilityCalendar from './availability_calendar.vue';
// import { personModel as model } from '../store/person.store';

export default {
  name: "AvailabilityAndInterests",
  data: () => ({
    days: [
      '2022-09-01', '2022-09-02', '2022-09-03', '2022-09-04', '2022-09-05'
    ]
  }),
  components: {
    AvailabilityCalendar
    // PeopleSidebar,
  }
}
</script>

<style>

</style>
