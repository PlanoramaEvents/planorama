<template>
  <div>
    <b-tabs content-class="mt-3" v-model="tabIndex" no-nav-style no-key-nav nav-class="nav-tabs-style">
      <b-tab title="Pierwsza" active lazy>
        <div class="d-flex flex-row">
          <h4>Projekty wiadomości</h4>
        </div>
        <div class="d-flex flex-row">
          <div class="p-6 col-sm">
            <combo-box
              :options='options'
              v-bind:select-size="4"
              :loading="loading"
              @change="onChange"
            ></combo-box>
          </div>

          <div class="d-flex flex-column">
            <b-button variant="primary" class="m-1" @click="onNewView">
              <b-icon-plus scale="2"></b-icon-plus>
            </b-button>
            <b-button variant="primary" class="m-1" @click="onView" :disabled="!selectedId" title="Zobacz">
              <b-icon-eye></b-icon-eye>
            </b-button>
            <b-button variant="primary" class="m-1" @click="onDelete" :disabled="!selectedId" title="Usuń">
              <b-icon-trash></b-icon-trash>
            </b-button>
          </div>

        </div>
        <div class="d-flex flex-row">
          <h4>Wysłane wiadomości</h4>
        </div>
        <div class="d-flex flex-row">
          <mailings-table
            defaultFilter='{"op":"all","queries":[["mailing_state", "!=", "draft"]]}'
            @view="onReadOnlyView"
            @clone="onClone"
            class="w-100"
          ></mailings-table>
        </div>
      </b-tab>
      <b-tab title="Druga" lazy>
        <mailing-editor
          :selectedId="selectedId"
          :readOnly="selected != null"
          model="mailing"
          @mailingSent="onManage"
        >
          <template v-slot:controls>
            <b-button variant="primary" @click="onManage">Powrót</b-button>
          </template>
        </mailing-editor>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import {http as axios} from '../http';
import ComboBox from '../components/combo_box';
import modelMixin from '../store/model.mixin';
import MailingsTable from './mailings_table.vue';
import MailingEditor from './mailing_editor.vue'
import { MAILING_CLONED } from '../constants/strings';

export default {
  name: "MailingsManager",
  components: {
    ComboBox,
    MailingsTable,
    MailingEditor
  },
  data () {
    return {
      options: [],
      data: [],
      loading: true,
      tabIndex: 0,
      selectedId: null
    }
  },
  mixins: [
    modelMixin
  ],
  watch: {
    data(newVal, oldVal) {
      if (newVal) {
        this.options = Object.values(newVal).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
            {
              value: obj.id,
              text: obj['display_name']
            }
          )
        )
      } else {
        this.options = []
      }
    }
  },
  methods: {
    onChange(arg) {
      this.selectedId = arg
    },
    onReadOnlyView() {
      if (this.selected) {
        this.selectedId = this.selected.id
        this.tabIndex = 1
      }
    },
    onClone() {
      if (this.selected) {
        let url = `/mailing/clone/${this.selected.id}`
        axios.get(url).then(
          () => {
            this.$bvToast.toast(
              MAILING_CLONED(this.selected.title),
              {
                variant: 'success',
                title: 'Mailing Cloned'
              }
            )
            this.load_draft_mailings()
          }
        )
      }
    },
    onView() {
      if (this.selectedId) {
        this.select(null);
        this.tabIndex = 1
      }
    },
    onNewView() {
      this.select(null);
      this.selectedId = null
      this.tabIndex = 1
    },
    onDelete() {
      if (this.selectedId) {
        this.delete_by_id(this.selectedId).then(
          () => {
            this.load_draft_mailings()
          }
        )
      }
    },
    onManage() {
      this.tabIndex = 0
      this.load_draft_mailings()
    },
    load_draft_mailings() {
      this.loading = true
      this.selectedId = null
      // Optimize by putting in field filter
      this.search({
        // This specifies limited set of fields to get
        "fields[mailing]": "id,display_name",
        // This specifies filtering i.e. we want only draft mailings
        filter: '{"op":"all","queries":[["mailing_state", "=", "draft"]]}'
      }).then(data => {
        this.data = data
        this.loading = false
      })
    },
    init() {
      this.load_draft_mailings()
    }
  }
}
</script>

<style lang="scss">
.nav-tabs-style {
  display: none !important;
}
</style>
