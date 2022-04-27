<template>
  <div>
    <div class="d-flex justify-content-between my-3" v-if="showControls">
      <search-vue
        class="w-75"
        :value="filter"
        @change="onSearchChanged"
        :columns="columns"
        v-if="showSearch"
        :stateName="stateName"
        ref="table-search"
      >
        <template v-slot:alternate-search-tab>
          <b-tab v-if="$slots['alternate-search']" ref="alternate-search-tab">
            <template #title>
              <slot name="alternate-search-title">
                Alternate Search
              </slot>
            </template>

            <slot name="alternate-search"></slot>
          </b-tab>
        </template>
      </search-vue>
      <div class="w-75" v-if="!showSearch">
      </div>

      <div class="d-flex justify-content-end">
        <div class="d-inline mx-1" title="clone" v-if="showClone">
          <b-button @click="$emit('clone')" variant="primary" title="clone">
            <b-icon-files></b-icon-files>
          </b-button>
        </div>
        <div class="d-inline mx-1" title="refresh" v-if="showRefresh">
          <b-button @click="onRefresh" variant="primary" title="refresh">
            <b-icon-arrow-repeat></b-icon-arrow-repeat>
          </b-button>
        </div>
        <div class="d-inline mx-1" title="newval" v-if="showAdd">
          <b-button @click="$emit('new')" variant="primary" title="New">
            <b-icon-plus></b-icon-plus>
          </b-button>
        </div>
        <div class="d-inline mx-1" title="show" v-if="showView">
          <b-button @click="$emit('view')" variant="primary" title="View">
            View
          </b-button>
        </div>
        <div class="d-inline" title="Settings" v-if="showSettings">
          <b-button disabled>
            <b-icon-gear-fill></b-icon-gear-fill>
          </b-button>
        </div>
      </div>
    </div>

    <div class="d-flex">
      <slot name="left-controls" v-bind:editableIds="editableIds"></slot>
      <b-pagination class="ml-auto"
        v-model="currentPage"
        :total-rows="totalRows"
        :per-page="perPage"
        first-text="First"
        last-text="Last"
        prev-text="Prev"
        next-text="Next"
      ></b-pagination>
    </div>
    <div class="d-flex">
      <span v-if="totalRows != fullTotalRows">Search Results: {{totalRows}}</span>
      <span class="ml-auto">Showing {{perPage < totalRows ? perPage : totalRows}} of {{fullTotalRows}} records</span>
    </div>
    <b-table
      hover bordered responsive selectable small striped
      :fields="tableColumns"
      selected-variant="primary"
      :select-mode="useSelectMode"

      :items="sortedCollection"

      ref="table"

      :no-local-sorting="true"
      :sort-by="sortBy"
      :sort-desc="sortDesc"

      @row-selected="onRowSelected"
      @sort-changed="onSortChanged"
    >
      <template #head(selected)="selected">
        <b-form-checkbox
          name="select-all-checkbox"
          value="select_all"
          unchecked-value="select_none"
          :checked="isSelectAll"
          @change="onSelectAll"
          >
        </b-form-checkbox>
      </template>
      <template #cell(selected)="row">
        <!-- {{ editable_ids }} -->
          <b-form-checkbox
            v-if="row.item"
            name="select-row-checkbox"
            :value="'select:'+row.item.id"
            :unchecked-value="'unselect:'+row.item.id"
            :checked="isChecked(row.item.id)"
            @change="onSelectRow"
            >
          </b-form-checkbox>
      </template>

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
    <div class="d-flex">
      <span v-if="totalRows != fullTotalRows">Search Results: {{totalRows}}</span>
      <span class="ml-auto">Showing {{perPage < totalRows ? perPage : totalRows}} of {{fullTotalRows}} records</span>
    </div>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';
import tableMixin from '../store/table.mixin';
import SearchVue from './search_vue'

export default {
  name: 'TableVue',
  components: {
    SearchVue
  },
  mixins: [
    modelMixin,
    tableMixin, // covers pagination and sorting
  ],
  props: {
    columns : { type: Array },
    selectMode: {
      type: String,
      default: 'single'
    },
    showControls: {
      type: Boolean,
      default: true
    },
    showSearch: {
      type: Boolean,
      default: true
    },
    showAdd: {
      type: Boolean,
      default: true
    },
    showSettings: {
      type: Boolean,
      default: true
    },
    showRefresh: {
      type: Boolean,
      default: false
    },
    showClone: {
      type: Boolean,
      default: false
    },
    showView: {
      type: Boolean,
      default: false
    },
    stateName: {
      type: String,
      default: null
    }
  },
  data () {
    return {
      selected_items: [],
      editable_ids: []
    }
  },
  computed: {
    useSelectMode() {
      if (this.selectMode == 'multi') {
        return 'range'
      }

      return 'single'
    },
    tableColumns() {
      if (this.selectMode != 'single') {
        let cols = [
          {
            key: 'selected',
            label: '',
          }
        ]

        return cols.concat(this.columns)
      } else {
        return this.columns
      }
    },
    editableIds() {
      return this.editable_ids
    },
    isSelectAll() {
      if (this.editable_ids.length == this.sortedCollection.length) {
        return "select_all"
      }
      return "select_none"
    }
  },
  methods: {
    isChecked(v) {
      if (this.editable_ids.includes(v)) {
        return `select:${v}`
      } else {
        return `unselect:${v}`
      }
    },
    onSelectRow(arg) {
      const args = arg.split(":")
      if (args[0] == 'select') {
        this.editable_ids.push(args[1])
      } else {
        this.editable_ids = this.editable_ids.filter(
          obj => (obj != args[1])
        )
      }
    },
    onSelectAll(arg) {
      if (arg == 'select_all') {
        this.editable_ids = this.sortedCollection.map(o => o.id)
      } else {
        this.editable_ids = []
      }
    },
    onRefresh() {
      // reset selected_items on page change as well ...
      this.selected_items = []
      this.editable_ids = []
      this.$refs.table.refresh()
    },
    onRowSelected(items) {
      this.selected_items = items
      if (items[0] && (items.length == 1)) {
        this.select(items[0]);
      } else {
        this.select(null);
      }
    },
    onSortChanged(ctx) {
      this.sortBy = ctx.sortBy;
      this.sortDesc = ctx.sortDesc;
    },
    onSearchChanged(arg) {
      this.filter = arg
    },
    setFilter(newFilter) {
      this.filter = newFilter
    },
    showAlternateSearch() {
      if (this.$refs['alternate-search-tab']) {
        this.$refs['alternate-search-tab'].activate()
      }
    }
  },
  watch: {
    selected(val) {
      if (!val && this.selected_items.length == 1) {
        this.$refs.table.clearSelected()
      }
    },
    currentPage(ov,nv) {
      if (ov != nv) {
        // page was changed so we clear our selected
        this.selected_items = []
        this.editable_ids = []
      }
    }
  },
  mounted() {
    // ensure that there is no model selected when the table is loaded
    this.editable_ids = []
    this.unselect();
  }
}
</script>

<!-- scoped does not work -->
<style lang="scss">
td {
  white-space: nowrap;
}

// Fix sticky col selection, not sure if this is quite the correct color etc
.table-primary > td.b-table-sticky-column {
  background-color: #d4d6f0 !important;
}
</style>
