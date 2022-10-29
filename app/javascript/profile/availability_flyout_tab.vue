<template>
  <div class="d-flex flex-column">
    <div class="flex-grow-1 flex-shrink-1 mb-4">
      <dl>
        <dt>Maximum number of program items across the duration of the convention</dt>
        <dd class="ml-2 font-italic">{{limits[null] || 'Not Set'}}</dd>
      </dl>
    </div>
    <div class="d-flex">
      <div class="flex-grow-1 flex-shrink-1 flex-basis-50">
        <dl>
          <dt>Selected Times</dt>
          <dd class="ml-2 font-italic text-muted" v-if="!availabilities.length && !availabilityLoading">None</dd>
          <b-overlay :show="availabilityLoading" spinner-variant="primary" style="min-height: 5rem;">
            <dd class="ml-2 font-italic" v-for="avail in availabilities" :key="avail">{{avail}}</dd>
          </b-overlay>
        </dl>
      </div>
      <div class="flex-grow-1 flex-shrink-1 flex-basis-50">
        <dl>
          <dt>Maximum number of program items per day</dt>
          <dd class="ml-2 font-italic mb-4">
            <table>
              <tr v-for="{text, value} of dayOptions" :key="`${text}-${value}`">
                <td>{{text}}&nbsp;</td>
                <td class="pl-3">{{limits[value] || 'Not Set'}}</td>
              </tr>
            </table>
          </dd>
          <dt>Do not schedule against these specific events</dt>
          <b-overlay :show="exclusionsLoading" spinner-variant="primary" style="min-height: 5rem;" class="mb-4">
            <dd class="ml-2 font-italic" v-for="exclusion in exclusions" :key="exclusion.id">
              {{exclusionsMap[exclusion.exclusion_id]}}
            </dd>
            <dd class="ml-2 font-italic text-muted" v-if="!exclusions.length">None Selected</dd>
          </b-overlay>
          <dt>Other scheduling considerations</dt>
          <dd class="ml-2 font-italic keep-format">{{selected.availability_notes}}</dd>
          <dd class="ml-2 font-italic text-muted" v-if="!selected.availability_notes">Not Specified</dd>
        </dl>
      </div>
    </div>
  </div> 
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import { modelMixinNoProp } from '@/store/model.mixin';
import { personModel as model} from '@/store/person.store';
import conventionTimezoneMixin from '@/shared/convention-timezone.mixin';
import { GET_AVAILABILITY } from '@/store/availability.store';
import { GET_PERSON_EXCLUSIONS } from '@/store/person_exclusion.store';
import { settingsMixin } from '@/mixins';

export default {
  name: "AvailabilityFlyoutTab",
  mixins: [
    modelMixinNoProp,
    conventionTimezoneMixin,
    settingsMixin,
  ],
  data: () => ({
    model,
    availabilityLoading: false,
    exclusionsLoading: false,
  }),
  computed: {
    ...mapGetters(['limitsForPerson', 'availabilitiesForPerson', 'exclusionsForPerson']),
    limits() {
      return this.selected 
        ? this.limitsForPerson(this.selected).reduce((p, c) => ({...p, [c.day]: c.max_sessions}), {})
        : [];
    },
    availabilities() {
      if(this.selected) {
          const availabilities = this.availabilitiesForPerson(this.selected);
          availabilities.sort((a, b) => a.start - b.start)
          return availabilities.map(a => `${a.start.setZone(this.conventionTimezone).toLocaleString({weekday: 'long', hour: 'numeric', minute: '2-digit'})} - ${a.end.setZone(this.conventionTimezone).toLocaleString({hour: 'numeric', minute: '2-digit', timeZoneName: 'short'})}`)
      }
      return [];
    },
    exclusions() {
      if (this.selected) {
        return this.exclusionsForPerson(this.selected);
      }
    },
    dayOptions() {
      return this.daysArray.map(d => ({text: d.toFormat('EEEE'), value: d.toFormat('y-MM-dd')}))
    }
  },
  methods: {
    ...mapActions({
      getAvailabilities: GET_AVAILABILITY,
      getExclusions: GET_PERSON_EXCLUSIONS
    }),
    fetchAvailability() {
      if (this.selected) {
        this.availabilityLoading = true;
        this.getAvailabilities({person: this.selected}).then(() => {
          this.availabilityLoading = false;
        })
      }
    },
    fetchExclusions() {
      if (this.selected) {
        this.exclusionsLoading = true;
        this.getExclusions({person: this.selected}).then(() => {
          this.exclusionsLoading = false;
        })
      }
    }
  },
  mounted() {
    this.fetchAvailability();
    this.fetchExclusions();
  },
  watch: {
    selected(newVal, oldVal) {
      if (newVal?.id !== oldVal?.id) {
        this.fetchAvailability();
        this.fetchExclusions();
      }
    }
  }
}
</script>

<style scoped lang="scss">

dd {
  margin-bottom: 0px;
}
</style>
