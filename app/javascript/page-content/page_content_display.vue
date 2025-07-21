<template>
  <div>
    <div v-if="collection.length > 0">
      <div v-for="content in collection" :key="content.id" v-html="content.html"></div>
    </div>
    <div v-else>
      <slot></slot>
    </div>
  </div>
</template>

<!-- 
  Given a name get that content from the backend and put in on the page

  TODO: a page content editor (name, html), as a seperate component
 -->
<script>
import { modelMixinNoProp } from '@/mixins'
import pageContentMixin from '@/page-content/page_content.mixin'

export default {
  name: "PageContentDisplay",
  props: {
    name: {
      type: String,
      default: null
    },
  },
  data: () => ({
    model: 'page_content'
  }),
  mixins: [
    modelMixinNoProp,
    pageContentMixin
  ],
  methods: {
  },
  mounted() {
    // get the content from the backend
    // backend restricts content to 1 for any given name anyway
    this.clear();
    this.fetch({filter: `{"op":"all","queries":[["name", "=", "${this.name}"]]}`});
  }
}
</script>

<style>
</style>
