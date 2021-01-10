<template>
  <section>
    <b-table
      :data="data"
      :columns="columns"
      :loading="loading"
      :striped=true
      :narrowed=true
      :hoverable=true
      :mobile-cards=false

      :selected.sync="selected"
      @select="onSelect"

      :debounce-search="1000"

      paginated
      backend-pagination
      :total="total"
      :per-page="perPage"
      @page-change="onPageChange"
      aria-next-label="Next page"
      aria-previous-label="Previous page"
      aria-page-label="Page"
      aria-current-label="Current page"

      backend-sorting
      default-sort-direction="asc"
      :default-sort="[sortField, sortOrder]"
      @sort="onSort"
    >
      <template v-for="column in columns">
        <b-table-column :key="column.id" v-bind="column">
          <template
            v-if="column.searchable && !column.numeric"
            slot="searchable"
            slot-scope="props">
            <b-input
              v-model="props.filters[props.column.field]"
              placeholder="Search..."
              icon="magnify"
              size="is-small" />
          </template>
          <template v-slot="props">
            {{ props.row[column.field] }}
          </template>
        </b-table-column>
      </template>
    </b-table>
  </section>
</template>

<script>
export default {
  name: 'TableComponent',
  props: {
    collection : { type: Object },
    columns : { type: Array }
  },
  data() {
    return {
      sortOrder: 'asc',
      sortField: null,
      selected: null,
      total: 0,
      defaultSortOrder: 'asc',
      loading: false,
      perPage: 20,
      page: 1,
      data: [],
    }
  },
  methods: {
//    onSave() {
//      this.selected.save()
//    },
    onSelect(row) {
      this.$emit('selected', row)
    },
    onPageChange(page) {
      this.page = page
      this.loadAsyncData()
    },
    onSort(field, order) {
      this.sortField = field
      this.sortOrder = order
      this.loadAsyncData()
    },
    loadAsyncData() {
      this.loading = true

      this.collection.clear()

      if (this.perPage) this.collection.set('perPage', this.perPage)
      if (this.sortOrder) this.collection.set('sortOrder', this.sortOrder)
      if (this.sortField) this.collection.set('sortField', this.sortField)

      this.collection.page(this.page).fetch().then(
        (arg) => {
          this.data = []
          this.total = arg.response.data.total
          this.perPage = arg.response.data.perPage
          this.collection.each((obj, index) => {
            this.data.push(obj)
          })
          this.loading = false
        }
      ).catch((error) => {
        this.data = []
        this.total = 0
        this.loading = false
        throw error
      })
    }
  },
  mounted() {
    this.loadAsyncData()
  }
}
</script>
