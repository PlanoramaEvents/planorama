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
        <b-tab title="Advanced">
          <vue-query-builder
            v-model="query"
            :rules="rules"
            :maxDepth="2"
            :styled="true"
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
      let query = null

        if (this.value) {
          query = {
            setting: {
              filter: filter,
              value: this.value
            }
          }
        } else {
          query = {
            setting: {}
          }
        }
      if (this.stateName) {
        query['key'] = this.stateName
        this.setSearchState(query)
      }

      // Add query to URL
      if (query) {
        this.$router.push({ path: this.$route.path, query: {q: JSON.stringify(query.setting)} })
        this.$emit('change', filter)
      }
    },
    onQuerySearch: function() {
      let filter = this.filter_by_query()
      let query = null

      if (this.stateName) {
        if (this.query) {
          query = {
            key: this.stateName,
            setting: {
              filter: filter,
              query: this.query
            }
          }
        } else {
          query = {
            key: this.stateName,
            setting: {}
          }
        }
      }

      // Add the query to the URL
      if (query) {
        this.setSearchState(query)
        this.$router.push({ path: this.$route.path, query: {q: JSON.stringify(query.setting)} })
        this.$emit('change', filter)
      }
    }
  },
  activated() {
  },
  mounted() {
    let saved = null;
    if (typeof this.$route.query.q != "undefined") {
      let param = this.$route.query.q
      saved = JSON.parse(param)
      this.setSearchState({key: this.stateName, setting: saved})
      this.$router.push({ path: this.$route.path, query: {q: param} })
    } else if (this.stateName) {
      saved = this.getSearchState()(this.stateName)
    }

    if (saved) {
      this.$router.push({ path: this.$route.path, query: {q: JSON.stringify(saved)} })

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
</script>

<style lang="scss" scoped>
</style>
