<template>
  <sidebar-vue :model="model">
    <template #header v-if="selected">
      <h1>
        {{selected.name}}
      </h1>
    </template>

    <template #content v-if="selected">
      <div class="float-right d-flex justify-content-end">
        <b-button title="Edit Person" variant="primary" :to="editLink"><b-icon-pencil variant="white"></b-icon-pencil></b-button>
      </div>
      <b-tabs content-class="mt-3" nav-class="border-0" nav-wrapper-class="border-bottom">
        <b-tab title="Summary">
          <detail :model="model"></detail>
        </b-tab>
        <!-- These need to be done and move to the people edit/tabs screen
         <b-tab title="Admin" v-if="currentUserIsAdmin">
          <people-admin-tab :model="model"></people-admin-tab>
        </b-tab>
        <b-tab title="Surveys">
          <people-surveys-tab :model="model"></people-surveys-tab>
        </b-tab> -->
      </b-tabs>
    </template>
  </sidebar-vue>
</template>

<script>
import SidebarVue from '../components/sidebar_vue';
import {personSessionMixin, modelMixin} from '@/mixins';
import Detail from './detail.vue';
import PeopleAdminTab from './people_admin_tab';
import PeopleSurveysTab from './people_surveys_tab';

export default {
  name: 'PeopleSidebar',
  components: {
    SidebarVue,
    Detail,
    PeopleAdminTab,
	PeopleSurveysTab,
  },
  mixins: [
    modelMixin,
    personSessionMixin
  ],
  computed: {
    editLink() {
      // This needs to be a different page
      return `/people/edit/${this.selected.id}`;
    }
  }
}
</script>
