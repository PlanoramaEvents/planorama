<template>
  <div class="d-flex flex-column">
    <div class="d-flex">
      <div class="flex-grow-1 flex-shrink-1">
        <dl>
          <template v-for="{text, value} of daysList">
            <dt :key="`${value}-label`">{{text}}</dt>
            <dd :key="`${value}-amount`" class="ml-2 font-italic">{{limits[value] || 'Not Set'}}</dd>
          </template>
        </dl>
      </div>
      <div class="flex-grow-1 flex-shrink-1">
        <p>Selected Times</p>
        <p>See edit tab</p>
      </div>
    </div>
  </div> 
</template>

<script>
import { mapGetters } from 'vuex';
import { modelMixinNoProp } from '@/store/model.mixin';
import { personModel as model} from '@/store/person.store';
import conventionTimezoneMixin from '@/shared/convention-timezone.mixin';
import { dateToEnUsFormat } from '@/utils';

export default {
  name: "AvailabilityFlyoutTab",
  mixins: [
    modelMixinNoProp,
    conventionTimezoneMixin,
  ],
  data: () => ({
    model,
  }),
  computed: {
    ...mapGetters(['limitsForPerson']),
    limits() {
      return this.selected 
        ? this.limitsForPerson(this.selected).reduce((p, c) => ({...p, [dateToEnUsFormat(c.day)]: c.max_sessions}), {})
        : [];
    },
    daysList() {
      return [{text: "Convention limit", value: null}, ...this.dayOptions];
    }
  },
  mounted() {
    console.log(this.limits, this.daysList)
  }
}
</script>

<style>

</style>
