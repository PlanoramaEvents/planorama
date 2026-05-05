<template>
<div class="mr-3">
  <b-form-select v-model="name" :options="options" class="w-50 mb-2">
  </b-form-select>
  <loading-overlay :loading="loading">
    <plano-editor
      v-model="content.html"
      type='classic'
      v-if="content"
    ></plano-editor>
  </loading-overlay>
  <div class="mt-2">
    <b-button variant="primary" @click="saveContent" class="mr-2">Save</b-button>
    <b-button variant="danger" @click="clearContent" :disabled="starter">Reset To Default</b-button>
  </div>
</div>
</template>

<script>
import { modelMixinNoProp } from '@/mixins'
import pageContentMixin from '@/page-content/page_content.mixin'
import PlanoEditor from '@/components/plano_editor';
import { scheduleWorkflowMixin } from '@/store/schedule_workflow';
import LoadingOverlay from '@/components/loading_overlay.vue';
export const pageContentModel = 'page_content';

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
      content: null,
      starter: false,
      name: 'dashboard-default',
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
      if (newVal != oldVal) {
        // fetch the content
        this.fetch_content()
      }
    },
  },
  methods: {
    clearContent() {
      this.deletePageContent(this.content).then(
        () => {
          this.fetch_content(true)
        }
      );
    },
    saveContent() {
      let _content = this.content
      if (this.starter) {
        _content = {
          name: this.name,
          html: this.content.html,
          _jv: {
            type: pageContentModel,            
          }
        }
        this.newPageContent(_content).then(
          (obj) => {
            this.starter = false
            this.content = obj
          }
        )
      } else {
        _content.name = this.name
        this.savePageContent(_content).then(
          (obj) => {
            this.content = obj
          }
        )
      }
    },
    fetch_content(starter = false) {
      if (this.name) {
        this.starter = starter
        this.loading = true;
        this.clear()
        let content_name = (starter) ? `${this.name}-starter` : `${this.name}`
        this.fetch({ filter: `{"op":"all","queries":[["name", "=", "${content_name}"]]}` }).then(
          (col) => {
            if (this.collection.length > 0) {
              this.content = this.collection[0]
            } else if (!starter) {
              this.fetch_content(true)
            }

            this.loading = false;
          }
        )
      }
    },
  },
  mounted() {
    this.fetchScheduleWorkflows().then(() => {
      if (this.draftSchedule) {
        this.name = 'dashboard-schedule';
      } else {
        this.fetch_content()
      }
    })
  }
}
</script>
