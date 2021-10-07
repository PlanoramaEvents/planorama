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

    <!-- NOTE:  items uses 'provider' function so that sortung works-->
    <b-pagination class="d-flex justify-content-end"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      first-text="First"
      last-text="Last"
      prev-text="Prev"
      next-text="Next"
    ></b-pagination>

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
import modelMixin from '../store/model.mixin';
export default {
  name: 'TableVue',
  mixins: [
    modelMixin,
  ],
  props: {
    sortField : { type: String },
    perPage : { type: Number, default: 10 },
    columns : { type: Object }
  },
  data() {
    return {
      selectMode: 'single',
      filter: null,
      currentPage: 1,
      totalRows: 0
    }
  },
  methods: {
    provider(ctx, callback) {
      this.fetch({
        perPage: ctx.perPage,
        sortOrder: ctx.sortDesc ? 'desc' : 'asc',
        sortBy: ctx.sortBy,
        filter: ctx.filter,
        page: ctx.currentPage
      }).then((data) => {
        var res = []
        Object.keys(data).forEach(function (key) {
          res.push(data[key])
        })

        this.currentPage = data._jv.json.meta.page
        this.totalRows = data._jv.json.meta.total

        callback(res)
      }).catch((error) => {
        callback([])
      })
    },
    onReset() {
      if (this.selected) this.fetchSelected();
    },
    onRowSelected(items) {
      this.select(items[0]);
    }
  },
  mounted() {
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
