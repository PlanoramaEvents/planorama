<template>
  <div class="p0">
    <b-input-group>
      <b-input-group-prepend>
        <b-input-group-text>
          <b-icon icon="search" />
        </b-input-group-text>
      </b-input-group-prepend>

      <b-form-input
        type="text"
        v-model="value"
        debounce="500"
        v-on:keyup.enter="onSearch"
      ></b-form-input>

      <b-input-group-append>
        <b-button variant="primary" @click="onSearch">Search</b-button>
      </b-input-group-append>
    </b-input-group>

    <b-button v-b-toggle.advanced-search variant="primary" class="mb-2 mt-2">Advanced Search</b-button>

    <b-collapse id="advanced-search" class="">
      <b-tabs content-class="mt-3" fill>
        <b-tab title="Advanced" active>
          <vue-query-builder
            v-model="query"
            :rules="rules"
            :maxDepth="2"
          >
          </vue-query-builder>
          <b-button variant="primary" @click="onQuerySearch">Search</b-button>
        </b-tab>
        <slot name="alternate-search-tab"></slot>
      </b-tabs>
    </b-collapse>
  </div>
</template>

<script>
import VueQueryBuilder from 'vue-query-builder';
import { query_to_rules } from "../utils";

export default {
  name: 'SearchVue',
  components: {
    VueQueryBuilder
  },
  props: {
    columns: Array
  },
  data() {
    return {
      value: null,
      query: {}
    }
  },
  computed: {
    rules() {
      let rule_set = []
      // compute based on the columns
      this.columns.forEach(
        (col) => {
          // only cols with types are searchable
          if (col.type) {
            rule_set.push(
              {
                type: col.type,
                id: col.search_key ? col.search_key : col.key,
                label: col.label,
                choices: col.choices
              }
            )
          }
        }
      )
      return rule_set
    }
  },
  methods: {
    filter_by_value() {
      return {
        "op":"all",
        "queries":[
          ["all","contains",this.value]
        ]
      }
    },
    filter_by_query() {
      return query_to_rules(this.query)
    },
    onSearch: function (event) {
      this.$emit('change', this.filter_by_value())
    },
    // onSearchClear: function (event) {
    //   this.value = null
    //   this.$emit('change', null)
    // },
    onQuerySearch: function() {
      // console.debug('*** QUERY THIS ', JSON.stringify(this.filter_by_query) )
      this.$emit('change', this.filter_by_query())
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
