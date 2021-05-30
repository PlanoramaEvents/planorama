<template>
  <div class="overflow-auto">
    <b-button @click="onNew">
      New
    </b-button>
    <b-button @click="onDelete">
      Delete
    </b-button>

    <b-pagination
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
    ></b-pagination>

    <b-table
      hover outlined responsive selectable
      :select-mode="selectMode"
      :fields="columns"

      :items="provider"

      :no-local-sorting="true"
      :sort-by="sortField"

      :per-page="perPage"
      :current-page="currentPage"
      :filter="filter"

      @row-selected="onRowSelected"
    ></b-table>
  </div>
</template>

<script>
import Vue from 'vue'
import { EventBus } from './event-bus';
import { BootstrapVue, BTable } from 'bootstrap-vue'
Vue.use(BootstrapVue)

export default {
  name: 'TableComponent',
  props: {
    modelType : { type: Function },
    collection : { type: Object },
    columns : { type: Array },
    sortField : { type: String },
    selectEvent : { type: String },
    // saveEvent : { type: String },
    perPage : { type: Number, default: 15 }
  },
  data() {
    return {
      selectMode: 'single',
      selected: null,
      currentPage: 1,
      filter: null,
      totalRows: 100
    }
  },
  methods: {
    provider(ctx, callback) {
      var sortOrder = ctx.sortDesc ? 'desc' : 'asc'

      if (ctx.perPage) this.collection.set('perPage', ctx.perPage)
      if (sortOrder) this.collection.set('sortOrder', sortOrder)
      if (ctx.sortBy) this.collection.set('sortField', ctx.sortBy)
      if (ctx.filter) this.collection.set('filter', ctx.filter)

      this.collection.clear()
      this.collection.page(ctx.currentPage).fetch().then(
        (arg) => {
          var res = []
          this.totalRows = arg.response.data.total
          this.perPage = arg.response.data.perPage
          this.collection.each((obj, index) => {
            res.push(obj)
          })

          callback(res)
        }
      ).catch((error) => {
        this.totalRows = 0
        callback([])
      })

      return null
    },
    onReset() {
      if (this.selected) this.selected.fetch()
    },
    onNew() {
      // this.selected.save()
      if (this.modelType) {
        this.selected = new this.modelType();
        if (this.selectEvent) {
          EventBus.emit(this.selectEvent, this.selected)
        }
      }
    },
    onDelete() {
      if (this.selected) {
        this.selected.delete().then(
          () => {
            this.$emit('selected', null)
            this.selected = null;
            if (this.selectEvent) {
              EventBus.emit(this.selectEvent, this.selected)
            }
            this.loadAsyncData()
          }
        )
      }
    },
    onRowSelected(items) {
      this.selected = items[0]
      if (this.selectEvent) {
        EventBus.emit(this.selectEvent, this.selected)
      }
    }
  }
}
</script>
