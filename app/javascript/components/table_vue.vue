<template>
  <div class="scrollable">

    <div class="d-flex justify-content-between my-3" v-if="showControls">
      <search-vue
        class="w-75"
        :value="filter"
        @change="onSearchChanged"
        :columns="columns"
        v-if="showSearch"
      >
      </search-vue>
      <div class="w-75" v-if="!showSearch">
      </div>

      <div class="d-flex justify-content-end">
        <!-- TODO: uploads are done in admin, UI shows this as a download which does not exist yet -->
        <!-- <div class="d-inline" title="Upload">
          <b-button disabled >
            <b-icon-upload></b-icon-upload>
          </b-button>
        </div> -->
        <div class="d-inline mx-1" title="clone" v-if="showClone">
          <b-button @click="$emit('clone')" variant="primary" title="clone">
            <b-icon-files scale="2"></b-icon-files>
          </b-button>
        </div>
        <div class="d-inline mx-1" title="refresh" v-if="showRefresh">
          <b-button @click="onRefresh" variant="primary" title="refresh">
            <b-icon-arrow-repeat scale="2"></b-icon-arrow-repeat>
          </b-button>
        </div>
        <div class="d-inline mx-1" title="newval" v-if="showAdd">
          <b-button @click="$emit('new')" variant="primary" title="New">
            <b-icon-plus scale="2"></b-icon-plus>
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

      :items="sortedCollection"

      ref="table"

      :no-local-sorting="true"
      :sort-by="sortBy"
      :sort-desc="sortDesc"

      @row-selected="onRowSelected"
      @sort-changed="onSortChanged"
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
    }
  },
  data() {
    return {
      selectMode: 'single',
    }
  },
  methods: {
    onRefresh() {
      this.$refs.table.refresh()
    },
    onRowSelected(items) {
      if (items[0]) {
        this.select(items[0]);
      }
    },
    onSortChanged(ctx) {
      this.sortBy = ctx.sortBy;
      this.sortDesc = ctx.sortDesc;
    },
    onSearchChanged(arg) {
      this.filter = arg
    }
  },
  watch: {
    selected(val) {
      if (!val) {
        this.$refs.table.clearSelected()
      }
    }
  },
  mounted() {
    // ensure that there is no model selected when the table is loaded
    this.unselect();
  }
}
</script>

<style lang="scss" scoped>
td {
  white-space: nowrap;
}
</style>
