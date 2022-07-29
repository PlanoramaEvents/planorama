import { conventionTimezoneMixin, settingsMixin } from '@/mixins';
import { DateTime } from 'luxon';
import {SESSION_STATUS} from '@/constants/strings'

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
      const session = this.session || this.selected;
      return session ? (!!session.room && !!session.start_time && !!session.duration) : false;
    }
  }
}

export const startTimeMixinNoSelected = {
  mixins: [
    conventionTimezoneMixin
  ],
  methods: {
    formatStartTime(session) {
      if(session.start_time) {
        return DateTime.fromISO(session.start_time, {zone: 'utc'}).setZone(this.conventionTimezone).toFormat('DDDD, t ZZZZ');
      }
      return '';
    },
  }
}

export const startTimeMixin = {
  mixins: [
    startTimeMixinNoSelected
  ],
  computed: {
    formattedStartTime() {
      return this.formatStartTime(this.selected);
    },
  }
}

export const sessionStatusMixin = {
  mixins: [
    settingsMixin
  ],
  computed: {
    sessionStatusOptions() {
      return this.currentSettings?.enums?.Session?.status?.map(value => ({text: SESSION_STATUS[value], value}))
    }
  }
}
