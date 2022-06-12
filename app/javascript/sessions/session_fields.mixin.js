import { conventionTimezoneMixin } from '@/mixins';
import { DateTime } from 'luxon';

export const areaMixin = {
  computed: {
    formattedAreaList() {
      return this.formatAreas(this.selected?.area_list);
    }
  },
  methods: {
    formatAreas(areas)  {
      return areas?.length ? areas.join(", ") : '';
    }
  }
}

export const scheduledMixin = {
  computed: {
    scheduled() {
      return this.session ? (!!this.session.room && !!this.session.start_time && !!this.session.duration) : false;
    }
  }
}

export const startTimeMixin = {
  mixins: [
    conventionTimezoneMixin
  ],
  computed: {
    formattedStartTime() {
      if(this.selected?.start_time) {
        return DateTime.fromISO(this.selected.start_time, {zone: 'utc'}).setZone(this.conventionTimezone).toFormat('DDDD, t ZZZZ');
      }
      return '';
    },
  }
}
