<template>
  <sidebar-vue :model="model">
    <template #header v-if="selected">
      <h1>
        {{selected.name}}
      </h1>
    </template>

    <template #content v-if="selected">
      <b-tabs content-class="mt-3">
        <b-tab title="Details">
          <detail :model="model"></detail>
        </b-tab>
        <b-tab title="Admin" v-if="currentUserIsAdmin">
          <people-admin-tab :model="model"></people-admin-tab>
        </b-tab>
        <b-tab title="Surveys">
          <people-surveys-tab :model="model"></people-surveys-tab>
        </b-tab>
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
  ]
}
</script>
