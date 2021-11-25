<template>
    <div>
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
        ></b-form-input>

        <b-input-group-append>
          <b-input-group-text>
            <b-icon
              icon="x"
              @click="onSearchClear"
            />
          </b-input-group-text>
          <b-button v-b-toggle.advanced-search variant="primary">Advanced Search</b-button>
        </b-input-group-append>
      </b-input-group>

      <b-collapse id="advanced-search" class="mt-2">
        <vue-query-builder
          v-model="query"
          :rules="rules"
          :maxDepth="2"
        >
        </vue-query-builder>
        <b-button variant="primary" @click="onQuerySearch">Search</b-button>
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
                id: col.key,
                label: col.label,
                choices: col.choices
              }
            )
          }
        }
      )
      return rule_set
    },
    filter_by_value() {
      // OLD way
      // return {
      //   rules: [
      //     ["all", "like", this.value]
      //   ]
      // }
      return {
        "op":"all",
        "queries":[
          ["all","contains",this.value]
        ]
      }
    },
    filter_by_query() {
      return query_to_rules(this.query)
    }
  },
  watch: {
    value (newval, oldval) {
      if (newval != oldval) {
        this.$emit('change', this.filter_by_value)
      }
    },
    query (newval, oldval) {
      // For testing/debug purposes
      console.debug('*** SEARCH QUERY ', JSON.stringify(newval) )
    }
  },
  methods: {
    onSearchClear: function (event) {
      this.value = null
      this.$emit('change', null)
    },
    onQuerySearch: function() {
      console.debug('*** QUERY THIS ', JSON.stringify(this.filter_by_query) )
      this.$emit('change', this.filter_by_query)
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
