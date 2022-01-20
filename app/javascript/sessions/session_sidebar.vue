<template>
  <sidebar-vue :model="model">
    <template #header v-if="selected">
      <h1>
        {{selected.title}}
      </h1>
    </template>

    <template #content v-if="selected">
      <b-tabs content-class="mt-3">
        <b-tab title="Details">
          <detail :model="model"></detail>
        </b-tab>
        <!-- <b-tab title="Admin" v-if="currentUserIsAdmin">
          <session-admin-tab :model="model"></session-admin-tab>
        </b-tab> -->
      </b-tabs>
    </template>
  </sidebar-vue>
</template>

<script>
import SidebarVue from '../components/sidebar_vue';
import {personSessionMixin, modelMixin} from '@/mixins';
import Detail from './detail.vue';
// import SessionAdminTab from './session_admin_tab';

export default {
  name: 'SessionSidebar',
  components: {
    SidebarVue,
    Detail,
    // SessionAdminTab
  },
  mixins: [
    modelMixin,
    personSessionMixin
  ]
}
</script>
