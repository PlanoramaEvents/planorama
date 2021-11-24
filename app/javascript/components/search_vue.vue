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
          rule_set.push(
            {
              type: col.type,
              id: col.key,
              label: col.label,
              choices: col.choices
            }
          )
        }
      )
      return rule_set
    },
    filter_by_value() {
      // Going to be the new way
      // return {
      //   rules: {
      //     op: 'all',
      //     queries: [
      //       ["all", "like", this.value]
      //     ]
      //   }
      // }
      // OLD way
      return {
        rules: [
          ["all", "like", this.value]
        ]
      }
    },
    filter_by_query() {
      // {
      //   "logicalOperator":"all",
      //   "children": [
      //     {
      //       "type":"query-builder-rule",
      //       "query":{
      //         "rule":"pronouns",
      //         "operator":"equals",
      //         "operand":"Pronouns",
      //         "value":null
      //       }
      //     },
      //     {
      //       "type":"query-builder-group",
      //       "query":{
      //         "logicalOperator":"any",
      //         "children":[
      //           {
      //             "type":"query-builder-rule",
      //             "query":{
      //               "rule":"published_name",
      //               "operator":"equals",
      //               "operand":"Published Name",
      //               "value":null
      //             }
      //           },
      //           {
      //             "type":"query-builder-rule",
      //             "query":{
      //               "rule":"registered",
      //               "operand":"Registered",
      //               "value":null
      //             }
      //           }
      //         ]
      //       }
      //     }
      //   ]
      // }
      // {
      //   op: 'all',
      //   queries: [
      //     ['col','op',val],
      //     ['col','op',val],
      //     {
      //       op: 'any',
      //       queries: [
      //         ['col','op',val],
      //         ['col','op',val]
      //       ]
      //     }
      //   ]
      // }
      console.debug('** op', this.query.logicalOperator)
      console.debug('** children', this.query.children)
      return {
        rules: {
          op: 'all',
          queries: [
            ["all", "like", this.value]
          ]
        }
      }
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
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
