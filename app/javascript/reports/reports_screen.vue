<template>
  <div class="mb-3 scrollable">
    <p class="mt-2">These are interim reports.</p>
    <ul>
      <li><a href="#participants">Participants</a></li>
      <li><a href="#sessions">Sessions</a></li>
      <li><a href="#conflicts">Conflicts</a></li>
      <li><a href="#schedule">Schedule</a></li>
    </ul>
    <h5><a id="participants"></a>Participants</h5>
    <ul>
      <li>
        <a href="/report/participant_selections" target="_blank">Participant Selections</a><br />
        <p class="ml-2">
          <strong><em>Description</em></strong>: Sessions and rankings selected by people, one line per person and session<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, session title, ranking, ranking notes, area(s) for the session, has person been assigned (y/n), has session been scheduled (y/n)<br />
          <strong><em>Session data included</em></strong>: any session selected by at least one person<br />
          <strong><em>Person data included</em></strong>: participant status of applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <a href="/report/participant_availabilities" target="_blank">Participant Availabilities</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Information in the person's &quot;Availability &amp; Interests&quot; tab (daily limit and con limit, days/times available, special events to attend)<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, attendance type (in-person, virtual, hybrid), availabilities (days/times), limits (daily &amp; con/&quot;global&quot;), exclusions (special events to attend), availability notes<br />
          <strong><em>Person data included</em></strong>: participant status of applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <a href="/report/assigned_sessions_by_participant" target="_blank">Assigned Sessions by Participant</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: People assigned to sessions, one line per person and session<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, session title, person’s role in the session, has session been scheduled (y/n)<br />
          <strong><em>Session data included</em></strong>: any session with at least one person assigned as moderator, participant, invisible participant, or reserved<br />
          <strong><em>Person data included</em></strong>: session role of moderator, participant, invisible participant, or reserved
        </p>
      </li>
      <li>
        <a href="/report/people_and_submissions" target="_blank">People and Survey Submissions</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: List of surveys taken, including day/time submitted, one line per person<br />
          <strong><em>Fields</em></strong>: Person name, published name, primary email, attendance type, participant status, surveys taken<br />
          <strong><em>Person data included</em></strong>: participant status of applied, probable, vetted, invite_pending, invited, accepted
        </p>      
      </li>
      <li>
        <a href="/report/participant_do_not_assign_with" target="_blank" v-if="currentUserIsAdmin">Participants and Do Not Assign With</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: People who should not be assigned to the same session, one line per person and session; available only to users with permission to view sensitive data<br />
          <strong><em>Fields</em></strong>: Person name, published name, session title, area(s) of session, names of other people assigned to the session, names of people not to assign to the same session<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions<br />
          <strong><em>Person data included</em></strong>: moderators, participants, invisible participants who listed information about who not to assign with
        </p>  
        <span v-if="currentUserIsStaff" class="text-muted font-italic" title="You do not have the right set of permissions to run this report." v-b-tooltip>Participants and Do Not Assign With</span>
      </li>
      <li>
        <a href="/report/session_reports/participants_over_session_limits" target="_blank">Participants over Daily Limits</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: People scheduled for more sessions than they specified in their daily and/or con limit, one line per person and daily/con limit exceeded<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, day (including individual days and &quot;All&quot; for con limit), session count (number of assigned sessions), person’s limit (as specified in &quot;Availabilities &amp; Interests&quot;)<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions<br />
          <strong><em>Person data included</em></strong>: moderators, participants exceeding specified daily or con limit
        </p>
      </li>
      <li>
        <a href="/report/session_reports/participants_over_con_session_limits" target="_blank">Participants over Con Limit</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: People scheduled for more sessions than the con allows, with some session format exceptions, one line per person<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, session count (number of assigned sessions), con limit (maximum number of sessions allowed by con of 6)<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions except those with format of autographing, meetings, readings, rehearsals, and table talks<br />
          <strong><em>Person data included</em></strong>: moderators, participants exceeding con limit of 6 sessions, not including the format exceptions
        </p>
      </li>
      <li>
        <a href="/report/session_reports/non_accepted_on_schedule" target="_blank">Non-Accepted Participants on Scheduled Sessions</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: People with participant status other than &quot;accepted&quot; or &quot;not_set&quot; assigned to scheduled sessions, one line per person and session<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, session title, area(s) of session<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions<br />
          <strong><em>Person data included</em></strong>: moderators, participants, invisible participants with a participant status that is not &quot;accepted&quot; or &quot;not_set&quot;
        </p>
      </li>
      <li>
        <a href="/report/session_reports/invited_accepted_not_scheduled" target="_blank">Invited and Accepted not on Schedule</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: People with a participant status of accepted, invited, or invite_pending who are not assigned to any sessions, one line per person<br />
          <strong><em>Fields</em></strong>: Person name, published name, participant status, attendance type (in-person, virtual, hybrid), person’s bio<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions<br />
          <strong><em>Person data included</em></strong>: people with a participant status of accepted, invited, or invite_pending who are assigned to no sessions, or who are assigned as invisible participants or reserved on one or more sessions
        </p>  
      </li>
    </ul>

    <h5><a id="sessions"></a>Sessions</h5>
    <ul>
      <li>
        <a href="/report/session_selections" target="_blank">Session Selections</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Sessions and rankings selected by people, one line per session and person<br />
          <strong><em>Fields</em></strong>: Session title, person name, person published name, participant status, ranking, ranking notes, area(s) of session<br />
          <strong><em>Session data included</em></strong>: all sessions that at least one person selected<br />
          <strong><em>Person data included</em></strong>: participant status of applied, probable, vetted, invite_pending, invited, accepted
        </p>
      </li>
      <li>
        <a href="/report/sessions_with_participants" target="_blank">Sessions with Participants</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Sessions with people already assigned, one line per session<br />
          <strong><em>Fields</em></strong>: Session title, session format, area(s) of session, moderators, participants, reserves, has session been scheduled (y/n)<br />
          <strong><em>Session data included</em></strong>: all sessions with at least one person assigned<br />
          <strong><em>Person data included</em></strong>: moderators, participants, reserved
        </p>
      </li>
      <li>
        <a href="/report/session_reports/session_with_no_moderator" target="_blank">Sessions with no Moderator</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Scheduled sessions with no moderator assigned, one line per session<br />
          <strong><em>Fields</em></strong>: Session title, area(s) of session, session start time, session format, people assigned (participants, invisible participants), reserved people<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions<br />
          <strong><em>Person data included</em></strong>: participants, invisible participants, reserved
        </p>
      </li>
      <li>
        <a href="/report/session_reports/scheduled_session_no_people" target="_blank">Scheduled Sessions with no Participants</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Scheduled sessions with no assigned moderators or participants, one line per session<br />
          <strong><em>Fields</em></strong>: Session title, area(s) of session, session start time, room<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions
        </p>  
      </li>
      <li>
        <a href="/report/session_reports/assigned_sessions_not_scheduled" target="_blank">Sessions with Participants not Scheduled</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Sessions that are not scheduled but have assigned people, one line per session<br />
          <strong><em>Fields</em></strong>: Session title, area(s) of session, moderators, participants, invisible participants<br />
          <strong><em>Session data included</em></strong>: all unscheduled sessions with at least one person assigned as moderator, participant, and/or invisible participant<br />
          <strong><em>Person data included</em></strong>: moderators, participants, invisible participants
        </p>
      </li>
      <li>
        <a href="/report/session_reports/panels_with_too_few_people" target="_blank">Panels with too few Participants</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Scheduled sessions (panel format only) with 3 or fewer assigned people (moderators, participants), one line per session<br />
          <strong><em>Fields</em></strong>: Session title, area(s) of session, session start time, participant count, participant count lower bound (3), assigned participants, moderators<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions<br />
          <strong><em>Person data included</em></strong>: moderators, participants
        </p>
      </li>
      <li>
        <a href="/report/session_reports/panels_with_too_many_people" target="_blank">Panels with too many Participants</a>
        <p class="ml-2">
          <strong><em>Description</em></strong>: Scheduled sessions (panel format only) with 6 or more assigned people (moderators, participants), one line per session<br />
          <strong><em>Fields</em></strong>: Session title, area(s) of session, session start time, participant count, participant count upper bound (6), assigned participants, moderators<br />
          <strong><em>Session data included</em></strong>: all scheduled sessions<br />
          <strong><em>Person data included</em></strong>: moderators, participants
        </p>
      </li>
      <li>
        <a href="/report/session_reports/session_copy_edit_status" target="_blank">Session Copy-Edit Status</a>
      </li>      
    </ul>

    <h5><a id="conflicts"></a>Conflicts</h5>
    <ul>
      <li>
        <a href="/report/conflict_reports/people_outside_availability" target="_blank">People outside of Availability</a>
      </li>
      <li>
        <a href="/report/conflict_reports/people_double_booked" target="_blank">People double booked</a>
      </li>
      <li>
        <a href="/report/conflict_reports/person_exclusion_conflicts" target="_blank">Person scheduled against a conflict item</a>
      </li>
      <li>
        <a href="/report/conflict_reports/back_to_back" target="_blank">Back to Back</a>
      </li>
      <li>
        <a href="/report/conflict_reports/back_to_back_to_back" target="_blank">Back to Back to Back</a>
      </li>
      <li>
        <a href="report/conflict_reports/multiple_sessions_in_room" target="_blank">Multiple Sessions in a Room</a>
      </li>
      <li>
        <a href="/report/conflict_reports/all_ignored_conflicts" target="_blank">Ignored Person Conflicts</a>
      </li>
      <li>
        <a href="/report/conflict_reports/all_conflicts" target="_blank">All Conflicts</a>
      </li>
    </ul>

    <h5><a id="schedule"></a>Schedule</h5>
    <ul>
      <li>
        <a href="/report/schedule_by_room_then_time" target="_blank">Schedule by Room then Time</a>
      </li>
      <li>
        <a href="/report/schedule_by_person" target="_blank">Schedule by Participant</a>
      </li>
      <!-- <li>
        <a href="/report/participants_with_approved_draft_schedule" target="_blank">Participants with approved draft schedule</a>
      </li> -->
      <!-- <li>
        <a href="/report/participants_with_approved_final_schedule" target="_blank">Participants with approved final schedule</a>
      </li> -->
    </ul>

  </div>
</template>

<script>
import personSessionMixin from '@/auth/person_session.mixin'

export default {
  name: "ReportsScreen",
  mixins: [
    personSessionMixin
  ]
}
</script>

<style>

</style>
