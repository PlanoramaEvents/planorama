<template>
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
</template>

<script>
import ModelSidebar from '../model-sidebar';
import Bio from './bio';

export default {
  name: 'PeopleSidebar',
  components: {
    ModelSidebar,
    Bio
  },
}
</script>
