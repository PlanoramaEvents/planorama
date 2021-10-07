<template>
<!--
  <model-sidebar
    title-field="published_name"
    namespace="people"
  >
    <template #tabs="{selected}">
      <b-tab title="Bio">
        <bio></bio>
        <ul>
          <li v-for="(val, field) in selected.bio" :key="field">{{field}}: {{val}}</li>
        </ul>
      </b-tab>
      <b-tab title="Tags">
        <p>TODO: Tags</p>
      </b-tab>
    </template>
  </model-sidebar>
-->
  <sidebar-vue model='person'>
  </sidebar-vue>
</template>

<script>
import SidebarVue from '../components/sidebar_vue';
//import Bio from './bio';

export default {
  name: 'PeopleSidebar',
  components: {
    SidebarVue,
 //   Bio
  },
}
</script>
