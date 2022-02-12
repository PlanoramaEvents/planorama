<template>
  <div class="container">
  <div class="row">
    <b-form-group label="Area" class="col-2">
      <model-select
        v-model="area_id"
        model="area"
        field="name"
        unselected-display="Any Area"
      ></model-select>
    </b-form-group>
    <b-form-group label="Tag" class="col-2">
      <model-tags
        v-model="tags"
        model="tag"
        field="name"
        filter='{"op":"all","queries":[["taggings.taggable_type", "=", "Session"]]}'
      ></model-tags>
    </b-form-group>
    <b-form-group label="Title or Description" class="col-4">
      <b-form-input
        type="text"
        v-model="title_desc"
      ></b-form-input>
    </b-form-group>
    <b-form-group class="col-2 align-self-end">
      <b-form-radio v-model="match" name="search-match" value="any">Match Any</b-form-radio>
      <b-form-radio v-model="match" name="search-match" value="all">Match All</b-form-radio>
    </b-form-group>
    <b-button variant="primary" @click="onSearch" class="col-2 align-self-end search-button">Search</b-button>
  </div>
  </div>
</template>

<script>
import ModelSelect from '../components/model_select';
import ModelTags from '../components/model_tags';

export default {
  name: 'SessionSearch',
  components: {
    ModelSelect,
    ModelTags
  },
  props: {
    columns: Array
  },
  data() {
    return {
      title_desc: null,
      area_id: null,
      tags: null,
      match: 'any'
    }
  },
  methods: {
    fields_to_query() {
      let queries = {
        "op": this.match,
        "queries": []
      }

      if (this.title_desc) {
        queries["queries"].push(
          ["title","contains",this.title_desc],
          ["description","contains",this.title_desc]
        )
      }

      if (this.area_id) {
        queries["queries"].push(
          ["session_areas.area_id","=",this.area_id],
        )
      }

      if (this.tags && (this.tags.length > 0)) {
        let vals = this.tags.map(obj => (obj.label))
        queries["queries"].push(
          ["tags.name","in",vals],
        )
      }

      return queries
    },
    onSearch: function (event) {
      this.$emit('change', this.fields_to_query())
    }
  }
}
</script>

<style lang="scss" scoped>
.search-button {
  margin-bottom: 1em;
}
</style>
