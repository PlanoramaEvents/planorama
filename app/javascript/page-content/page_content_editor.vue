<template>
<div>
  <b-form-select v-model="name" :options="options"></b-form-select>
  <plano-editor
    v-model="content.html"
    type='classic'
  ></plano-editor>
  <!-- TODO - do we want a delete? -->
  <b-button variant="primary" @click="saveContent">Save</b-button>

</div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins'
import pageContentMixin from '@/page-content/page_content.mixin'
import PlanoEditor from '@/components/plano_editor';

export default {
  name: "PageContentEditor",
  components: {
    PlanoEditor,
  },
  data() {
    return {
      model: 'page_content',
      loading: true,
      content: this.starter_content(),
      name: null,
      options: [
        // NOTE: put in as many options as we want text for
        // dashboard-intro is the introduction test for the dashboard (sans any publish)
        { value: 'dashboard-intro', text: 'dashboard-intro' },
        // stuff is just a dummy example
        { value: 'dashboard-stuff', text: 'dashboard-stuff' }
      ]
    }
  },
  mixins: [
    modelMixinNoProp,
    pageContentMixin
  ],
  watch: {
    name(newVal, oldVal) {
      if (newVal) {
        // fetch the content
        this.fetch_content()
      }
    }
  },
  methods: {
    starter_content() {
      return {
        id: null,
        name: '',
        html: ''
      }
    },
    saveContent() {
      let res = this.savePageContent(this.content);
      res.then(
        (obj) => {
          this.content = obj
        }
      )
    },
    fetch_content() {
      if (this.name) {
        this.clear()
        this.fetch({ filter: `{"op":"all","queries":[["name", "=", "${this.name}"]]}` }).then(
          (col) => {
            if (this.collection.length > 0) {
              this.content = this.collection[0]
            } else {
              this.content = this.starter_content()
              this.content.name = this.name
            }
          }
        )
      }
    },
  }
}
</script>
