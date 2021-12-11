<template>
  <div>
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
        <b-button variant="primary" class="m-1">
          <b-icon-plus scale="2"></b-icon-plus>
        </b-button>
        <b-button variant="primary" class="m-1">View</b-button>
        <b-button variant="primary" class="m-1">Delete</b-button>
      </div>

    </div>
    <div class="d-flex flex-row">
      <h4>Sent Mailings</h4>
    </div>
    <div class="d-flex flex-row">
      <!-- TODO: add filter for search ... -->
      <mailings-table></mailings-table>
    </div>
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
      loading: true
    }
  },
  props: {
    attribute: String
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
              text: obj[this.attribute]
            }
          )
        )
      } else {
        this.options = []
      }
    }
  },
  methods: {
    init() {
      this.loading = true
      // TODO: optimize by putting in field filter
      this.search({}).then(data => {
        this.data = data
        this.loading = false
      })
    }
  }
}
</script>

<style>

</style>
