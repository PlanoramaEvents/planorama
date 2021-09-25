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

    <b-table
      hover bordered responsive selectable small striped
      :select-mode="selectMode"
      :fields="model.tableFields()"
      selected-variant="primary"

      :items="model.provider"

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
import { SELECT } from './model.store';
import { Model } from '@vuex-orm/core';

export default {
  name: 'TableVuexorm',
  props: {
    model: {
      type: Model,
      required: true
    },
    sortField : { type: String },
    perPage : { type: Number, default: 10 }
  },
  data() {
    return {
      selectMode: 'single',
      filter: null,
      currentPage: 1,
    }
  },
  mixins: [],
  computed: {
    totalRows() {
      return this.model.query().count();
    },
    selected() {
      return this.model.getters('selected')
    }
  },
  methods: {
    onReset() {
      // What goes here
    },
    onRowSelected(items) {
      this.model.commit(SELECT, items[0].id)
    }
  },
  mounted() {
    this.model.fetch();
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
