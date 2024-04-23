<template>
<div class="mr-3">
  <b-form-select v-model="name" :options="options" class="w-50 mb-2">
    <template #first>
      <option :value="null">Wybierz obszar treści do edycji</option>
    </template>
  </b-form-select>
  <plano-editor
    v-model="content.html"
    type='classic'
  ></plano-editor>
  <!-- TODO - do we want a delete? -->
  <b-button variant="primary" @click="saveContent">Zapisz</b-button>
  <!-- <b-button variant="danger" @click="clearContent">Reset To Default</b-button> -->
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
        { value: 'dashboard-default', text: 'Dashboard - Default' },
        { value: 'dashboard-schedule', text: 'Dashboard - After Draft Publish' }
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
    clearContent() {
      console.debug("**** DELETE", this.content)
      this.deletePageContent(this.content).then(
        () => {
          this.content = this.starter_content()
        }
      );
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
