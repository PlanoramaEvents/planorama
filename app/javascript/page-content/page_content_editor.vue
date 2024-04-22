<template>
  <div class="mr-3">
    <stepper :steps="options" v-model="name"></stepper>
    <plano-editor v-model="content.html" type="classic"></plano-editor>
    <!-- TODO - do we want a delete? -->
    <div class="d-flex flex-row-reverse py-2">
      <b-button variant="primary" @click="saveContent">Save</b-button>
      <b-button variant="danger" class="mx-2" v-b-modal.reset-modal
        >Reset To Default</b-button
      >
    </div>
    <plano-modal id="reset-modal" no-close-on-backdrop @ok="clearContent()" ok-title="Reset" ok-variant="danger">
      <template #modal-title>Reset to Default?</template>
      {{RESET_TO_DEFAULT[content.name]}}
    </plano-modal>
  </div>
</template>

<script>
import { modelMixinNoProp } from "@/mixins";
import pageContentMixin from "@/page-content/page_content.mixin";
import PlanoEditor from "@/components/plano_editor";
import Stepper from "@/components/stepper.vue";
import { RESET_TO_DEFAULT} from "@/constants/strings";
import PlanoModal from "@/components/plano_modal.vue";

export default {
  name: "PageContentEditor",
  components: {
    PlanoEditor,
    Stepper,
    PlanoModal,
  },
  data() {
    return {
      model: "page_content",
      loading: true,
      content: this.starter_content(),
      name: "dashboard-default",
      options: [
        { value: "dashboard-default", text: "Dashboard - Default" },
        {
          value: "dashboard-schedule",
          text: "Dashboard - After Draft Publish",
        },
      ],
      RESET_TO_DEFAULT,
    };
  },
  mixins: [modelMixinNoProp, pageContentMixin],
  watch: {
    name: {
      handler(newVal, oldVal) {
        if (newVal) {
          // fetch the content
          this.fetch_content();
        }
      },
      immediate: true,
    },
  },
  methods: {
    starter_content() {
      return {
        id: null,
        name: "",
        html: "",
      };
    },
    clearContent() {
      console.debug("**** DELETE", this.content);
      this.deletePageContent(this.content).then(() => {
        this.content = this.starter_content();
      });
    },
    saveContent() {
      let res = this.savePageContent(this.content);
      res.then((obj) => {
        this.content = obj;
      });
    },
    fetch_content() {
      if (this.name) {
        this.clear();
        this.fetch({
          filter: `{"op":"all","queries":[["name", "=", "${this.name}"]]}`,
        }).then((col) => {
          if (this.collection.length > 0) {
            this.content = this.collection[0];
          } else {
            this.content = this.starter_content();
            this.content.name = this.name;
          }
        });
      }
    },
  },
};
</script>
