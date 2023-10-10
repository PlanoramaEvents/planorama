<template>
<div class="container-fluid scrollable">
  <h1>Preview features</h1>
  <h2>Page content editor (for the dashboard)</h2>
  <page-content-editor></page-content-editor>
</div>
</template>

<script>
import PageContentEditor from "@/page-content/page_content_editor.vue"

export default {
  name: "PlayGroundComponent",
  components: {
    PageContentEditor
  },
}
</script>

<style></style>
