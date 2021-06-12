<template>
  <model-sidebar
    title-field="published_name"
  >
    <template #tabs="{selected}">
      <b-tab title="Bio">
        <p>{{selected.bio}}</p>
      </b-tab>
      <b-tab title="Tags">
        <p>TODO: Tags</p>
      </b-tab>
    </template>
  </model-sidebar>
</template>

<script>
import ModelSidebar from '../model-sidebar';

export default {
  name: 'PeopleSidebar',
  components: {
    ModelSidebar
  },
}
</script>
