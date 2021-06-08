<template>
  <model-sidebar
    title-field="published_name"
  >
    <template #tabs>
      <b-tab title="Bio">
        <p>TODO: BIO</p>
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
