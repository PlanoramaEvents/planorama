<template>
  <div class="container">
  <div class="row">
    <!--
    Area (drop down)
    Tag
    Title or Description
    match any/match all
    -->
    <b-form-group label="Area" class="col-2">
      <b-form-input
        type="text"
      ></b-form-input>
    </b-form-group>
    <b-form-group label="Tag" class="col-3">
      <b-form-input
        type="text"
      ></b-form-input>
    </b-form-group>
    <b-form-group label="Title or Description" class="col-5">
      <b-form-input
        type="text"
        v-model="title_desc"
      ></b-form-input>
    </b-form-group>
    <b-button variant="primary" @click="onSearch" class="col-2 align-self-end search-button">Search</b-button>
  </div>
  </div>
</template>
<!-- align-self-end search-button -->
<script>
// import { query_to_rules } from "../utils";

export default {
  name: 'SessionSearch',
  components: {
  },
  props: {
    columns: Array
  },
  data() {
    return {
      title_desc: null,
      query: {}
    }
  },
  computed: {
    // rules() {
    //   let rule_set = []
    //   // compute based on the columns
    //   this.columns.forEach(
    //     (col) => {
    //       // only cols with types are searchable
    //       if (col.type) {
    //         rule_set.push(
    //           {
    //             type: col.type,
    //             id: col.search_key ? col.search_key : col.key,
    //             label: col.label,
    //             choices: col.choices
    //           }
    //         )
    //       }
    //     }
    //   )
    //   return rule_set
    // }
  },
  methods: {
    filter_by_value() {
      let queries = {
        "op":"any",
        "queries":[]
      }

      if (this.title_desc) {
        queries["queries"].push(
          ["title","contains",this.title_desc],
          ["description","contains",this.title_desc]
        )
      }

      // TODO: change
      return queries
    },
    // filter_by_query() {
    //   return query_to_rules(this.query)
    // },
    onSearch: function (event) {
      this.$emit('change', this.filter_by_value())
    },
    // onSearchClear: function (event) {
    //   this.value = null
    //   this.$emit('change', null)
    // },
    // onQuerySearch: function() {
    //   // console.debug('*** QUERY THIS ', JSON.stringify(this.filter_by_query) )
    //   this.$emit('change', this.filter_by_query())
    // }
  }
}
</script>

<style lang="scss" scoped>
.search-button {
  margin-bottom: 1em;
}
</style>
