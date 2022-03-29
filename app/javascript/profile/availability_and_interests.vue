<template>
  <div>
    <div class="mb-3">
      Availbility and Interests
    </div>
    <availability-calendar
      :days="days"
      model="availability"
    ></availability-calendar>
  </div>
</template>

<script>
import AvailabilityCalendar from './availability_calendar.vue';
// import { personModel as model } from '../store/person.store';

export default {
  name: "AvailabilityAndInterests",
  data: () => ({
    // TODO: if there are more than 5 days in the con we need to change display
    days: [
      '2022-09-01', '2022-09-02', '2022-09-03', '2022-09-04', '2022-09-05' //, '2022-09-06', '2022-09-07'
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
