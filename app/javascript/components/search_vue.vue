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

    <b-button v-b-toggle.advanced-search variant="primary" class="mb-2 mt-2">Wyszukiwanie zaawansowane</b-button>
    <b-collapse id="advanced-search" class="">
      <b-tabs content-class="mt-3" fill>
        <b-tab title="Advanced">
          <vue-query-builder
            v-model="query"
            :rules="rules"
            :maxDepth="2"
          >
          </vue-query-builder>
          <b-button variant="primary" @click="onQuerySearch">Wyszukaj</b-button>
        </b-tab>
        <slot name="alternate-search-tab"></slot>
      </b-tabs>
    </b-collapse>
  </div>
</template>

<script>
import VueQueryBuilder from 'vue-query-builder';
import { query_to_rules } from "../utils";
import searchStateMixin from '../store/search_state.mixin'

export default {
  name: 'SearchVue',
  components: {
    VueQueryBuilder
  },
  props: {
    columns: Array,
    stateName: {
      type: String,
      default: null
    }
  },
  mixins: [searchStateMixin],
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
            const rule_opts = {
              type: col.type,
              id: col.search_key ? col.search_key : col.key,
              label: col.label,
              component: col.component,
              // TODO stop hard coding dynamic choices in search component
              choices: col.choices === 'dynamic' ? this.dynamicChoices(col.key) : col.choices
            }
            if (col.operators) {
              rule_opts.operators = col.operators;
            }
            rule_set.push(rule_opts)
          }
        }
      )
      return rule_set
    }
  },
  methods: {
    dynamicChoices(key) {
    },
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
      let filter = this.filter_by_value()

      if (this.stateName) {
        if (this.value) {
          this.setSearchState({
            key: this.stateName,
            setting: {
              filter: filter,
              value: this.value
            }
          })
        } else {
          this.setSearchState({
            key: this.stateName,
            setting: {}
          })
        }
      }

      this.$emit('change', filter)
    },
    // onSearchClear: function (event) {
    //   this.value = null
    //   this.$emit('change', null)
    // },
    onQuerySearch: function() {
      let filter = this.filter_by_query()

      if (this.stateName) {
        if (this.query) {
          this.setSearchState({
            key: this.stateName,
            setting: {
              filter: filter,
              query: this.query
            }
          })
        } else {
          this.setSearchState({
            key: this.stateName,
            setting: {}
          })
        }
      }

      this.$emit('change', filter)
    }
  },
  mounted() {
    if (this.stateName) {
      let saved = this.getSearchState()(this.stateName)
      if (saved) {
        if (saved.value) {
          this.value = saved.value
        }
        if (saved.query) {
          this.query = saved.query

          if (saved.filter.queries.length > 0) {
            this.$root.$emit('bv::toggle::collapse', 'advanced-search')
          }
        }
        this.$emit('change', saved.filter)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
