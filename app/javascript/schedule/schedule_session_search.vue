<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <b-form-group label="Area" label-cols="4">
          <model-select
            size="sm"
            v-model="area_id"
            model="area"
            field="name"
            unselected-display="Any Area"
          ></model-select>
        </b-form-group>
      </div>
      <div class="col-12">
        <b-form-group label="Title" label-cols="4">
          <b-form-input
            type="text"
            v-model="title_desc"
            size="sm"
          ></b-form-input>
        </b-form-group>
      </div>
      <div class="col-9">
        <b-form-radio-group v-model="match" :options="[{text: 'Match Any', value: 'any'}, {text: 'Match All', value:'all'}]" size="sm">
        </b-form-radio-group>
      </div>
      <div class="col-3 px-0">
        <b-button variant="primary" @click="onSearch" size="sm">Search</b-button>
      </div>
    </div>
  </div>
</template>

<script>
import ModelSelect from '../components/model_select';
import ModelTags from '../components/model_tags';
import searchStateMixin from '../store/search_state.mixin'

const SAVED_SEARCH_STATE = "SCHEDULABLE SESSION SELECT STATE";

export default {
  name: 'ScheduleSessionSearch',
  components: {
    ModelSelect,
    ModelTags
  },
  mixins: [
    searchStateMixin
  ],
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
          {
            "op": "any",
            "queries": [
              ["title","contains",this.title_desc],
            ]
          }
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
      this.setSearchState({
        key: SAVED_SEARCH_STATE,
        setting: {
          title_desc: this.title_desc,
          area_id: this.area_id,
          tags: this.tags,
          match: this.match
        }
      })
      this.$emit('change', this.fields_to_query())
    },
    init() {

      let saved = this.getSearchState()(SAVED_SEARCH_STATE)
      // console.debug("**** INIT ", saved)
      if (saved) {
        this.title_desc = saved.title_desc
        this.area_id = saved.area_id
        this.tags = saved.tags
        this.match = saved.match
        this.$emit('change', this.fields_to_query())
      }
    }
  },
  mounted() {
    this.init();
  }
}
</script>

<style lang="scss" scoped>
</style>
