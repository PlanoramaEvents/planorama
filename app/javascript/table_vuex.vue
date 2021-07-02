<template>
  <div class="scrollbox">
    <div class="d-flex justify-content-end my-3">
      <b-button disabled >
        <b-icon-upload></b-icon-upload>
      </b-button>
      <b-button @click="$emit('new')" class="mx-1" variant="primary">
        <b-icon-plus scale="2"></b-icon-plus>
      </b-button>
      <b-button disabled>
        <b-icon-gear-fill></b-icon-gear-fill>
      </b-button>
    </div>

    <div class="d-flex justify-content-end">
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
      selected-variant="primary"

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

    <b-pagination class="d-flex justify-content-end"
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
    onRowSelected(items) {
      console.log('row selected', items)
      this.selected = items[0]
      this.$store.commit(SELECT, this.selected);
    }
  }
}
</script>

<style lang="scss" scoped>
td {
  white-space: nowrap;
}

.scrollbox {
  overflow-y: auto;
  max-height: calc(100vh - 100px)
}
</style>
