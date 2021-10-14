<template>
  <sidebar-vue
    model="person"
    v-slot:content
  >
    <b-tabs content-class="mt-3">
      <b-tab title="Details">
        <bio></bio>
        <pre>{{ selected }}</pre>
      </b-tab>
      <b-tab title="Bio">
        <bio></bio>
        <pre>{{ selected.bio }}</pre>
      </b-tab>
      <b-tab title="Tags">
        <p>TODO: Tags</p>
      </b-tab>
    </b-tabs>
    <!-- <pre>{{ selected }}</pre> -->
  </sidebar-vue>
</template>

<script>
import SidebarVue from '../components/sidebar_vue';
import modelMixin from '../store/model.mixin';
//import Bio from './bio';

export default {
  name: 'PeopleSidebar',
  components: {
    SidebarVue,
 //   Bio
  },
  mixins: [
    modelMixin
  ]
}
</script>
