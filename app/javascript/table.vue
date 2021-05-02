<template>
  <section>
    <b-button @click="onNew">
      New
    </b-button>
    <b-button @click="onDelete">
      Delete
    </b-button>
    <!-- :primary-key="id" -->
    <b-table
      hover outlined responsive selectable
      :select-mode="selectMode"
      :fields="columns"

      :items="provider"

      :no-local-sorting="true"
      :sort-by.sync="sortField"
      :sort-desc.sync="sortDesc"

      :per-page.sync="perPage"
      :current-page.sync="currentPage"
      :filter.sync="filter"
    ></b-table>
  </section>
</template>

<script>
export default {
  // import { NavbarPlugin } from 'bootstrap-vue'
  // import { BTable } from 'bootstrap-vue'
  name: 'TableComponent',
  props: {
    collection : { type: Object },
    columns : { type: Array }
  },
  data() {
    return {
      selectMode: 'single',
      sortField: null,
      sortDesc: false,
      selected: null,
      perPage: 15,
      currentPage: 1,
      filter: null,
      total: 0
    }
  },
  methods: {
    provider(ctx, callback) {
      var sortOrder = ctx.sortDesc ? 'desc' : 'asc'

      if (ctx.perPage) this.collection.set('perPage', ctx.perPage)
      if (sortOrder) this.collection.set('sortOrder', sortOrder)
      if (ctx.sortField) this.collection.set('sortField', ctx.sortBy)
      if (ctx.filter) this.collection.set('filter', ctx.filter)

      this.collection.clear()
      this.collection.page(ctx.currentPage).fetch().then(
        (arg) => {
          var data = []
          this.total = arg.response.data.total
          // this.perPage = arg.response.data.perPage
          this.collection.each((obj, index) => {
            data.push(obj)
          })

          callback(data)
        }
      ).catch((error) => {
        this.total = 0
        callback([])
      })

      return null
    },

    onNew() {
      // this.selected.save()
      this.$emit('create', false);
    },
    onDelete() {
      if (this.selected) {
        // this.selected.delete().then(
        //   () => {
        //     this.$emit('selected', null);
        //     this.selected = null;
        //     this.loadAsyncData()
        //   }
        // )
      }
    }
//    onSelect(row) {
//      this.$emit('selected', row)
//  },
  }
}
</script>
