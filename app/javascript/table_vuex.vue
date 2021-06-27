<template>
  <div class="overflow-auto">
    <div class="d-flex flex-row-reverse my-3">
      <b-button disabled class="ml-1">
        Settings
      </b-button>
      <b-button @click="onNew" class="mx-1" variant="primary">
        Add
      </b-button>
      <b-button disabled >
        Upload
      </b-button>
    </div>

    <div class="d-flex">
      <b-pagination
        v-model="currentPage"
        :total-rows="totalRows"
        :per-page="perPage"
        first-text="First"
        last-text="Last"
        prev-text="Prev"
        next-text="Next"
      ></b-pagination>
    </div>

    <b-table
      hover bordered responsive selectable small striped
      :select-mode="selectMode"
      :fields="columns"

      :items="provider"

      ref="table"

      :no-local-sorting="true"
      :sort-by="sortField"

      :per-page="perPage"
      :current-page="currentPage"
      :filter="filter"

      @row-selected="onRowSelected"
    >
      <slot v-for="(_, name) in $slots" :name="name" :slot="name" />
      <template v-for="(_, name) in $scopedSlots" :slot="name" slot-scope="slotData">
        <slot :name="name" v-bind="slotData" />
      </template>
    </b-table>

    <b-pagination class="float-right"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      first-text="First"
      last-text="Last"
      prev-text="Prev"
      next-text="Next"
    ></b-pagination>
  </div>
</template>

<script>
import Vue from 'vue'
import { BootstrapVue, BTable } from 'bootstrap-vue'
import { SELECT } from './model.store';
import { mapState } from 'vuex';
Vue.use(BootstrapVue)

export default {
  name: 'TableVuex',
  props: {
    modelType : { type: Function },
    sortField : { type: String },
    perPage : { type: Number, default: 10 }
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
  computed: mapState(['collection', 'columns']),
  methods: {
    provider(ctx, callback) {
      var sortOrder = ctx.sortDesc ? 'desc' : 'asc'

      if (ctx.perPage) this.collection.set('perPage', ctx.perPage)
      if (sortOrder) this.collection.set('sortOrder', sortOrder)
      if (ctx.sortBy) this.collection.set('sortField', ctx.sortBy)
      if (ctx.filter) this.collection.set('filter', ctx.filter)

      this.collection.clear()
      // TODO use vuex here to fetch as a wrapper
      this.collection.page(ctx.currentPage).fetch().then(
        (arg) => {
          var res = []
          this.totalRows = arg.response.data.meta.total
          this.perPage = arg.response.data.meta.perPage
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
    onRowSelected(items) {
      console.log('row selected', items)
      this.selected = items[0]
      this.$store.commit(SELECT, this.selected);
    }
  }
}
</script>

<style lang="scss">
td {
  white-space: nowrap;
}
</style>
