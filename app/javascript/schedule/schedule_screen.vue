<template>
    <div class="container-fluid pl-0">
      <div class="row">
        <div class="col-3 mt-3">
          <schedule-session-search></schedule-session-search>
          <schedulable-sessions
            :model="sessionModel"
            :defaultFilter="sessionFilter"
            defaultSortBy="sessions.title"
            ref="schedulable-sessions"
          >
          </schedulable-sessions>
          <div>
          <room-selector
            v-if="rooms"
            :rooms="rooms"
            @change="onRoomChange"
            class="v-100"
          ></room-selector>
          </div>
        </div>
        <div class="col-9 scrollable">
          <schedule-calendar
            :rooms="rooms"
            :selectedRooms="selectedRooms"
            :days="days"
            :timezone="timezone"
            v-if="(selectedRooms && selectedRooms.length > 0) && days.length > 0"
            :defaultFilter="scheduleFilter"
            :model="sessionModel"
            :perPage="2000"
            @schedule-changed="onScheduleChanged"
            class="mt-3"
          ></schedule-calendar>
        </div>
      </div>
    </div>
</template>

<script>
import RoomSelector from './room_selector'
import SchedulableSessions from './schedulable_sessions'
import ScheduleCalendar from './schedule_calendar'
import modelUtilsMixin from "@/store/model_utils.mixin";
import settingsMixin from "@/store/settings.mixin";
import { roomModel } from '../store/room.store.js';
import { sessionModel } from '@/store/session.store'
import ScheduleSessionSearch from './schedule_session_search';

import { DateTime } from "luxon";

export default {
  name: "ScheduleScreen",
  components: {
    ScheduleCalendar,
    SchedulableSessions,
    RoomSelector,
    ScheduleSessionSearch
  },
  mixins: [
    modelUtilsMixin,
    settingsMixin
  ],
  data: () =>  ({
    rooms: null,
    sessionModel: sessionModel,
    selectedRooms: []
  }),
  computed: {
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
          ["start_time", "is null"],
          ["duration", ">", "0"]
        ]
      }

      return JSON.stringify(filter)
    }
  },
  methods: {
    onRoomChange: function(rooms) {
      this.selectedRooms = rooms
    },
    onScheduleChanged: function() {
      this.$refs["schedulable-sessions"].fetchPaged(false)
    },
    init: function() {
      this.selectedRooms = this.rooms.map((r) => r.id)
    },
  },
  mounted() {
    this.fetch_models(roomModel).then(data => {
      this.rooms = Object.values(data).filter(
        obj => (typeof obj.json === 'undefined')
      )
      this.init()
    })
  }
}
</script>

<style lang="scss">
</style>
