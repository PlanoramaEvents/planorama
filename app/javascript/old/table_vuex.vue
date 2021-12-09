<template>
  <div class="scrollable">
    <div class="d-flex justify-content-end my-3">
      <div class="d-inline" title="Upload">
        <b-button disabled >
          <b-icon-upload></b-icon-upload>
        </b-button>
      </div>
      <b-button @click="$emit('new')" class="mx-1" variant="primary" title="New">
        <b-icon-plus scale="2"></b-icon-plus>
      </b-button>
      <div class="d-inline" title="Settings">
        <b-button disabled>
          <b-icon-gear-fill></b-icon-gear-fill>
        </b-button>
      </div>
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

    <!-- NOTE:  items uses 'provider' function so that sortung works-->
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
import { SELECT } from './store/model.store';
import namespacedMixin from './namespaced.mixin';

export default {
  name: 'TableVuex',
  props: {
    sortField : { type: String },
    perPage : { type: Number, default: 10 }
  },
  data() {
    return {
      selectMode: 'single',
      filter: null,
      currentPage: 1
    }
  },
  mixins: [
    namespacedMixin(['collection', 'columns', 'selected'], {select: SELECT})
  ],
  computed: {
    // NOTE: this does not use bootstrap vue's pager and table integration with provider
    // which then breaks the sorting
    // currentPage: {
    //   get() {
    //     return this.collection ? this.collection.currentPage : 1;
    //   },
    //   set(val) {
    //     this.collection.currentPage = val
    //     //
    //     this.collection.page(this.collection.currentPage).fetch();
    //   }
    // },
    totalRows() {
      return this.collection ? this.collection.total : 0;
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
          this.perPage = arg.response.data.meta.perPage
          this.collection.each((obj, index) => {
            res.push(obj)
          })

          callback(res)
        }
      ).catch((error) => {
        callback([])
      })

      return null
    },
    onReset() {
      if (this.selected) this.selected.fetch()
    },
    onRowSelected(items) {
      // console.log('row selected', items)
      this.select(items[0]);
    }
  },
  mounted() {
    this.collection.perPage = this.perPage
    this.collection.fetch().catch((error) => {})
  },
  watch: {
    selected(val) {
      if (!val) {
        this.$refs.table.clearSelected()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
td {
  white-space: nowrap;
}
</style>
