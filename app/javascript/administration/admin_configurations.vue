<template>
<div class="scrollable">
  <h1>Configurations</h1>
  <b-tabs content-class="mt-3 container-fluid">
    <b-tab title="Dashboard Content Editor">
      <page-content-editor></page-content-editor>
    </b-tab>
  </b-tabs>
</div> 
</template>

<script>
import PageContentEditor from '@/page-content/page_content_editor.vue';

export default {
  name: "AdminConfigurations",
  components: {
    PageContentEditor
  }
}
</script>

<style>

</style>
