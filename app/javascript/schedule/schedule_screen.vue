<template>
  <div class="container-fluid pl-0">
    <div class="row">
      <div class="col-3 pt-3 d-flex flex-column" style="max-height: calc(100vh - 150px)">
        <schedulable-sessions
          :model="sessionModel"
          :defaultFilter="sessionFilter"
          defaultSortBy="sessions.title"
          ref="schedulable-sessions"
          style="flex: 1 0 auto"
        >
        </schedulable-sessions>
        <session-conflicts
          :model="sessionConflictModel"
          :sessionId="sessionIdForConflict"
          :timezone="timezone"
          style="flex: 1 0 auto"
          ref="conflict-reporting"
        ></session-conflicts>
      </div>
      <div class="col-9">
        <div class="d-flex justify-content-end">
          <magical-reload class="mt-1" title="Przeładuj harmonogram" label="Harmonogram ostatnio przeładowany o"></magical-reload>
          <room-selector></room-selector>
        </div>
        <div class="scrollable minus31">
          <schedule-calendar
            :rooms="rooms"
            :selectedRooms="selectedRooms"
            :days="days"
            :timezone="timezone"
            v-if="(selectedRooms && selectedRooms.length > 0) && days.length > 0"
            :defaultFilter="scheduleFilter"
            :model="sessionModel"
            @schedule-changed="onScheduleChanged"
            @show-conflicts="onShowConflicts"
            class="mt-1"
          ></schedule-calendar>
        </div>
      </div>
    </div>
    <session-sidebar :model="sessionModel"></session-sidebar>
  </div>
</template>

<script>
import RoomSelector from './room_selector'
import SchedulableSessions from './schedulable_sessions'
import ScheduleCalendar from './schedule_calendar'
import modelUtilsMixin from "@/store/model_utils.mixin";
import settingsMixin from "@/store/settings.mixin";
import { roomModel, SET_ROOMS_FOR_SCHEDULING } from '../store/room.store.js';
import { sessionModel } from '@/store/session.store'
import { sessionConflictModel } from '@/store/session_conflict.store'
import SessionSidebar from '../sessions/session_sidebar.vue';
import SessionConflicts from '../conflicts/session_conflicts.vue'
import MagicalReload from '@/components/magical_reload.vue'

import { DateTime } from "luxon";
import { mapActions, mapState, mapGetters } from 'vuex';
import { FETCH } from '@/store/model.store';

export default {
  name: "ScheduleScreen",
  components: {
    ScheduleCalendar,
    SchedulableSessions,
    RoomSelector,
    SessionSidebar,
    SessionConflicts,
    MagicalReload
  },
  mixins: [
    modelUtilsMixin,
    settingsMixin
  ],
  data: () =>  ({
    sessionModel: sessionModel,
    sessionConflictModel: sessionConflictModel,
    sessionIdForConflict: null
  }),
  computed: {
    ...mapState({
      selectedRooms: 'roomsForScheduling'
    }),
    ...mapGetters({
      rooms: 'fetchedRooms'
    }),
    start_time() {
      if (this.currentSettings && this.currentSettings.configs) {
        let st = this.configByName('convention_start_time')
        return DateTime.fromISO(st)
      } else {
        return null
      }
    },
    end_time() {
      if (this.currentSettings && this.currentSettings.configs) {
        let et = this.configByName('convention_end_time')
        return DateTime.fromISO(et)
      } else {
        return null
      }
    },
    days() {
      if (!this.start_time || !this.end_time) return []

      let start_day = this.start_time.setZone(this.calTimeZone).startOf('day')
      let end_day = this.end_time.setZone(this.calTimeZone).endOf('day')
      let nbr_days = Math.round(end_day.diff(start_day, 'days').as('days'))
      let res = []
      for (let i = 0; i < nbr_days; i++ ) {
        let d = start_day.toFormat('yyyy-MM-dd') //toLocaleString(DateTime.DATE_SHORT)
        res.push(d)
        start_day = start_day.plus({days: 1})
      }
      return res
    },
    timezone() {
      let tz = this.configByName('convention_timezone')
      return tz
    },
    scheduleFilter() {
      let filter = {
        "op": "all",
        "queries":[
          ["start_time", "is not null"]
        ]
      }

      return JSON.stringify(filter)
    },
    sessionFilter() {
      // Only sessions that have a duration can be scheduled
      let filter = {
        "op": "all",
        "queries":[
          // {
          //   "op": "any",
          //   "queries":[
          //     ["start_time", "is null"],
          //     ["room_id", "is null"]
          //   ]
          // },
          ["duration", ">", "0"],
          ["status", "!=", "dropped"]
        ]
      }

      return JSON.stringify(filter)
    }
  },
  methods: {
    ...mapActions({
      fetch: FETCH
    }),
    onScheduleChanged: function(id) {
      this.$refs["schedulable-sessions"].fetchPaged(false)
      // update the conflicts
      if (this.sessionIdForConflict == id) {
        this.$refs["conflict-reporting"].refreshConflicts()
      } else {
        this.sessionIdForConflict = id
      }
    },
    onShowConflicts: function(session_id) {
      this.sessionIdForConflict = session_id
    }
  },
  mounted() {
    this.fetch({model: roomModel}).then((rooms) => {
      if (!this.selectedRooms.length) {
        this.$store.commit(SET_ROOMS_FOR_SCHEDULING, Object.values(rooms).map(r => r.id).filter(r => r))
      }
    })
  }
}
</script>

<style lang="scss">
</style>
