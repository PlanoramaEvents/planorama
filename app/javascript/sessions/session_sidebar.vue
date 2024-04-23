<template>
  <div class="detail">
    <sidebar-vue v-if="selected" model="session">
      <template #header>
        <h3>{{selected.title}}</h3>
        <small class="text-muted d-block">Ostatnio zaktualizowane</small>
        <!-- <small class="text-muted d-block"> by <em><strong>{{selected.updated_by && selected.updated_by.name}}</strong></em></small> -->
        <small class="text-muted d-block"> w <em><strong>{{new Date(selected.updated_at).toLocaleString()}}</strong></em></small>
      </template>
      <template #content v-if="selected">
        <b-row>
          <b-col>
            <dl>
              <dt>Status:</dt>
              <dd class="ml-2">
                {{SESSION_STATUS[selected.status]}}
              </dd>
              <dt>
                Opis:
              </dt>
              <dd class="ml-2">
                <div v-html="selected.description"></div>
              </dd>
            </dl>
          </b-col>
        </b-row>
        <b-row>
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group>
              <b-form-checkbox v-model="selected.open_for_interest" disabled switch>
                Otwarte na zainteresowanie
              </b-form-checkbox>
            </b-form-group>
          </div>
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group>
              <b-form-checkbox switch v-model="selected.proofed" disabled>
                Skorygowane/zweryfikowane
              </b-form-checkbox>
            </b-form-group>
          </div>
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group>
              <b-form-checkbox switch disabled :checked="scheduled">
                Zaplanowane
              </b-form-checkbox>
            </b-form-group>
          </div>
        </b-row>
        <div class="row">
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group label="Public Schedule Visibility">
              <span class="text-muted ml-2">Niewidoczne</span>
              <b-form-checkbox
                switch
                disabled
                :checked="selected.visibility === 'is_public'"
                class="d-inline-block"
              >Widoczne</b-form-checkbox>
            </b-form-group>
          </div>
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group>
              <b-form-checkbox
                id="session-recorded"
                switch
                v-model="selected.recorded"
                disabled
              >Zostanie nagrane</b-form-checkbox>
            </b-form-group>
          </div>
          <div class="col-12 col-md-6 col-lg-4">
            <b-form-group>
              <b-form-checkbox
                id="session-streamed"
                switch
                v-model="selected.streamed"
                disabled
              >Będzie transmitowane na żywo</b-form-checkbox>
            </b-form-group>
          </div>
        </div>
        <div class="float-right d-flex justify-content-end">
          <b-button title="Edytuj sesję" variant="primary" :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></b-button>
        </div>
        <b-tabs content-class="mt-3" nav-class="border-0" nav-wrapper-class="border-bottom">
          <!-- TODO: more details etc -->
            <b-tab title="Ogólne" active lazy>
            <dl>
              <dt>Obszary</dt>
              <dd v-if="selected.area_list.length" class="ml-2 font-italic">{{formattedAreaList}}</dd>
              <dd v-if="!selected.area_list.length" class="ml-2 font-italic text-muted">Brak wybranych</dd>
              <dt>Format</dt>
              <dd class="ml-2 font-italic" v-if="selected.format">{{selected.format.name}}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.format">Brak wybranego</dd>
              <dt>Środowisko sesji</dt>
              <dd class="ml-2 font-italic">{{SESSION_ENVIRONMENT[selected.environment]}}</dd>
              <dt>Publiczne tagi</dt>
              <dd class="ml-2 font-italic" v-if="selected.tag_list.length">{{ formatTags(selected.tag_list) }}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.tag_list.length">Brak wybranych</dd>
              <dt>Etykiety administracyjne</dt>
              <dd class="ml-2 font-italic" v-if="selected.label_list.length">{{ formatTags(selected.label_list) }}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.label_list.length">Brak wybranych</dd>
              <dt>Ustawienie sali</dt>
              <dd class="ml-2 font-italic" v-if="selected.room_set">{{selected.room_set.name}}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.room_set">Brak wybranego</dd>
              <dt>Wymagana rejestracja uczestników</dt>
              <dd class="ml-2 font-italic">{{selected.require_signup ? 'Tak' : 'Nie'}}</dd>
              <dt class="ml-2">Jeśli "Tak", maksymalna liczba miejsc</dt>
              <dd class="ml-3 font-italic">{{selected.audience_size}}</dd>
              <dd class="ml-3 font-italic text-muted" v-if="!selected.audience_size">Brak ustawionej</dd>
              <dt>Ograniczenia wiekowe uczestników</dt>
              <dd class="ml-2 font-italic" v-if="selected.age_restriction_id">{{ ageRestrictionName(selected.age_restriction_id)}}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.age_restriction_id">Brak</dd>
              <dt>Udział nieletnich</dt>
              <dd class="ml-2 font-italic" v-for="mp in minors_participation" :key="mp">{{ SESSION_MINORS_PARTICIPATION[mp]}}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!minors_participation.length">Brak wybranych</dd>
              <dt>Instrukcje dotyczące zainteresowania</dt>
              <dd class="ml-2 font-italic" v-html="selected.instructions_for_interest"></dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.instructions_for_interest">Brak wpisu</dd>
              <dt>Wymagane cechy/usługi sali</dt>
              <dd class="ml-2 font-italic keep-format">{{selected.room_notes}}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.room_notes">Brak wpisu</dd>
              <dt>Notatki dotyczące uczestników w harmonogramie</dt>
              <dd class="ml-2 font-italic" v-html="selected.participant_notes"></dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.participant_notes">Brak wpisu</dd>
              <dt>Notatki dotyczące technologii/hotelu</dt>
              <dd class="ml-2 font-italic keep-format">{{selected.tech_notes}}</dd>
              <dd class="ml-2 font-italic text-muted" v-if="!selected.tech_notes">Brak wpisu</dd>
            </dl>
          </b-tab>
          <b-tab title="Przypisanie uczestników">
            <view-participants :session="selected"></view-participants>
          </b-tab>
          <b-tab title="Harmonogram">
            <dl>
              <dt>Przestrzeń</dt>
              <dd v-if="selected.room" class="ml-2 font-italic">{{selected.room.name}}</dd>
              <dd v-if="!selected.room" class="ml-2 font-italic text-muted">Brak wybranej przestrzeni</dd>
              <dt>Czas</dt>
              <dd v-if="selected.start_time" class="ml-2 font-italic">{{formattedStartTime}}</dd>
              <dd v-if="!selected.start_time" class="ml-2 font-italic text-muted">Brak wybranego czasu</dd>
              <dt>Czas trwania</dt>
              <dd class="ml-2 font-italic">{{selected.duration}} minut</dd>
            </dl>
          </b-tab>
          <b-tab title="Konflikty" lazy>
            <session-conflicts
              :model="sessionConflictModel"
              :sessionId="selected.id"
              :displaySessionInfo="false"
              ref="conflict-reporting"
            ></session-conflicts>
          </b-tab>
          <b-tab title="Notatki">
            <session-notes></session-notes>
          </b-tab>
          <!-- <survey-settings-tab></survey-settings-tab> -->
        </b-tabs>
      </template>
    </sidebar-vue>
  </div>
</template>

<script>
import SidebarVue from '@/components/sidebar_vue';
import SessionNotes from './session_notes.vue';
import ViewParticipants from './view_participants';
import {personSessionMixin, modelMixin} from '@/mixins';
import Detail from './detail.vue';
import { areaMixin, scheduledMixin, startTimeMixin } from './session_fields.mixin';
import { sessionConflictModel } from '@/store/session_conflict.store';
import SessionConflicts from '@/conflicts/session_conflicts.vue';
// import SessionAdminTab from './session_admin_tab';
import { SESSION_ENVIRONMENT, SESSION_STATUS} from '@/constants/strings';
import { minorsParticipationMixin } from './minors_participation.mixin';
import { ageRestrictionMixin } from './age_restriction.mixin';
import { tagsMixin } from '@/store/tags.mixin'

export default {
  name: 'SessionSidebar',
  components: {
    SidebarVue,
    Detail,
    SessionNotes,
    ViewParticipants,
    SessionConflicts
  },
  mixins: [
    modelMixin,
    personSessionMixin,
    areaMixin,
    scheduledMixin,
    startTimeMixin,
    minorsParticipationMixin,
    ageRestrictionMixin,
    tagsMixin,
  ],
  data: () => ({
    sessionConflictModel,
    SESSION_ENVIRONMENT,
    SESSION_STATUS,
  }),
  computed: {
    editLink() {
      return `/sessions/edit/${this.selected.id}`;
    },
  }
}
</script>
