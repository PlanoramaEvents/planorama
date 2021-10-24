<template>
  <sidebar-vue model="person">
    <template #header v-if="selected">
      <h1>
        {{selected.name}}
      </h1>
    </template>

    <template #content v-if="selected">
      <b-tabs content-class="mt-3">
        <b-tab title="Details">
          <detail model="person"></detail>
        </b-tab>
        <b-tab title="Email Addresses">
          <pre>{{ selected.email_addresses }}</pre>
        </b-tab>
        <b-tab title="Bio">
          <bio v-bind:bio="selected.bio"></bio>
        </b-tab>
        <b-tab title="Roles">
          <pre>{{ selected.person_roles }}</pre>
        </b-tab>
        <b-tab title="Tags">
          <pre>{{ selected.tags }}</pre>
        </b-tab>
        <b-tab title="Mail History">
          <pre>{{ selected.mail_histories }}</pre>
        </b-tab>
      </b-tabs>
    </template>
  </sidebar-vue>
</template>

<script>
import SidebarVue from '../components/sidebar_vue';
import modelMixin from '../store/model.mixin';
import Bio from './bio.vue';
import Detail from './detail.vue';

export default {
  name: 'PeopleSidebar',
  components: {
    SidebarVue,
    Bio,
    Detail
  },
  mixins: [
    modelMixin
  ]
}
</script>
