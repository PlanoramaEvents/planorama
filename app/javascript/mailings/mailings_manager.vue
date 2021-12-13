<template>
  <div>
    <b-tabs content-class="mt-3" v-model="tabIndex" no-nav-style no-key-nav nav-class="nav-tabs-style">
      <b-tab title="First" active lazy>
        <div class="d-flex flex-row">
          <h4>Draft Mailings</h4>
        </div>
        <div class="d-flex flex-row">
          <div class="p-6 col-sm">
            <combo-box
              :options='options'
              v-bind:select-size="4"
              :loading="loading"
            ></combo-box>
          </div>

          <div class="d-flex flex-column">
            <b-button variant="primary" class="m-1" @click="onView">
              <b-icon-plus scale="2"></b-icon-plus>
            </b-button>
            <b-button variant="primary" class="m-1" @click="onView">View</b-button>
            <b-button variant="primary" class="m-1">Delete</b-button>
          </div>

        </div>
        <div class="d-flex flex-row">
          <h4>Sent Mailings</h4>
        </div>
        <div class="d-flex flex-row">
          <mailings-table
            defaultFilter='{"op":"all","queries":[["mailing_state", "!=", "draft"]]}'
          ></mailings-table>
        </div>
      </b-tab>
      <b-tab title="Second" lazy>
        <b-button variant="primary" class="m-1" @click="onManage">Back</b-button>

        TODO
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
import ComboBox from '../components/combo_box';
import modelMixin from '../store/model.mixin';
import MailingsTable from './mailings_table.vue';

export default {
  name: "MailingsManager",
  components: {
    ComboBox,
    MailingsTable
  },
  data () {
    return {
      options: [],
      data: [],
      loading: true,
      tabIndex: 0
    }
  },
  // props: {
  //   attribute: String
  // },
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
    onView() {
      this.tabIndex = 1
    },
    onManage() {
      this.tabIndex = 0
    },
    init() {
      this.loading = true
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
    }
  }
}
</script>

<style lang="scss">
.nav-tabs-style {
  display: none !important;
}
</style>
