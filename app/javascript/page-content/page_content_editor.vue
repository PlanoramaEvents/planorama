<template>
<div class="mr-3">
  <b-form-select v-model="name" :options="options" class="w-50 mb-2">
  </b-form-select>
  <loading-overlay :loading="loading"> 
    <plano-editor
      v-model="content.html"
      type='classic'
    ></plano-editor>
  </loading-overlay>
  <!-- TODO - do we want a delete? -->
  <b-button variant="primary" @click="saveContent" class="mt-2">Save</b-button>
  <!-- <b-button variant="danger" @click="clearContent">Reset To Default</b-button> -->
</div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins'
import pageContentMixin from '@/page-content/page_content.mixin'
import PlanoEditor from '@/components/plano_editor';
import { scheduleWorkflowMixin } from '@/store/schedule_workflow';
import LoadingOverlay from '@/components/loading_overlay.vue';

export default {
  name: "PageContentEditor",
  components: {
    PlanoEditor,
    LoadingOverlay,
  },
  data() {
    return {
      model: 'page_content',
      loading: true,
      content: this.starter_content(),
      name: this.draftSchedule ? 'dashboard-schedule' : 'dashboard-default',
      options: [
        { value: 'dashboard-default', text: 'Dashboard - Default' },
        { value: 'dashboard-schedule', text: 'Dashboard - After Draft Publish' }
      ]
    }
  },
  mixins: [
    modelMixinNoProp,
    pageContentMixin,
    scheduleWorkflowMixin
  ],
  watch: {
    name(newVal, oldVal) {
      if (newVal) {
        // fetch the content
        this.fetch_content()
      }
    },
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
  },
  mounted() {
    this.fetchScheduleWorkflows().then(() => {
      if (this.draftSchedule && this.name === 'dashboard-default') {
        this.name = 'dashboard-schedule';
      }
      this.loading = false;
    })
  }
}
</script>
