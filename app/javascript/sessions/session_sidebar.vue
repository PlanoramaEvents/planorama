<template>
  <div class="detail">
    <sidebar-vue v-if="selected" model="session">
      <template #header>
        <h3>{{selected.title}}</h3>
        <small class="text-muted d-block">Last updated:</small>
        <!-- <small class="text-muted d-block"> by <em><strong>{{selected.updated_by && selected.updated_by.name}}</strong></em></small> -->
        <small class="text-muted d-block"> on <em><strong>{{new Date(selected.updated_at).toLocaleString()}}</strong></em></small>
      </template>
      <template #content v-if="selected">
        <b-row>
          <b-col>
            <dl>
              <dt>
                Description:
              </dt>
              <dd>
                <div v-html="selected.description"></div>
              </dd>
            </dl>
          </b-col>
        </b-row>
        <div class="float-right d-flex justify-content-end">
          <b-button title="Edit Session" variant="primary" :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></b-button>
        </div>
        <b-tabs content-class="mt-3" nav-class="border-0" nav-wrapper-class="border-bottom">
          <!-- TODO: more details etc -->
          <b-tab title="General" active>
            <b-form-checkbox v-model="selected.open_for_interest" disabled switch>
              Open for Interest
            </b-form-checkbox>
          </b-tab>
          <b-tab title="Participants">
            <view-participants :session="selected"></view-participants>
          </b-tab>
          <b-tab title="Notes">
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
// import SessionAdminTab from './session_admin_tab';

export default {
  name: 'SessionSidebar',
  components: {
    SidebarVue,
    Detail,
    SessionNotes,
    ViewParticipants
  },
  mixins: [
    modelMixin,
    personSessionMixin
  ],
  computed: {
    editLink() {
      return `/sessions/edit/${this.selected.id}`;
    },
  }
}
</script>
