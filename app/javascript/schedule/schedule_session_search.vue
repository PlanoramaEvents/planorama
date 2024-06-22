<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <b-form-group label="Area" label-cols="4">
          <model-select size="sm" v-model="area_id" model="area" field="name"
            unselected-display="Any Area"></model-select>
        </b-form-group>
      </div>
      <div class="col-12">
        <b-form-group label="Title" label-cols="4">
          <b-form-input type="text" v-model="title_desc" size="sm"></b-form-input>
        </b-form-group>
      </div>
      <div class="col-12">
        <b-form-group label="Tag" label-cols="4">
          <b-form-select v-model="tag" :options="sessionTagsDropDownOptions" size="sm">
          </b-form-select>
        </b-form-group>
      </div>
      <div class="col-12">
        <b-form-group label="Label" label-cols="4">
          <b-form-select v-model="label" :options="sessionLabelsDropDownOptions" size="sm">
          </b-form-select>
        </b-form-group>
      </div>
      <!-- Add Label - drop down -->
      <div class="col-9">
        <b-form-radio-group v-model="match"
          :options="[{text: 'Match Any', value: 'any'}, {text: 'Match All', value:'all'}]" size="sm">
        </b-form-radio-group>
      </div>
      <div class="col-3 px-0">
        <b-button variant="primary" @click="onSearch" size="sm">Search</b-button>
      </div>
    </div>
    <!-- radio for none, time only, space only -->
    <div class="row">
      <div class="col-12">
        <b-form-radio-group v-model="schedFilter">
          <b-form-radio value="all">All</b-form-radio>
          <b-form-radio value="time">Time</b-form-radio>
          <b-form-radio value="room">Room</b-form-radio>
        </b-form-radio-group>
      </div>
    </div>
  </div>
</template>

<script>
import ModelSelect from '../components/model_select';
import ModelTags from '../components/model_tags';
import searchStateMixin from '../store/search_state.mixin'
import { tagsMixin } from '@/store/tags.mixin';

const SAVED_SEARCH_STATE = "SCHEDULABLE SESSION SELECT STATE";

export default {
  name: 'ScheduleSessionSearch',
  components: {
    ModelSelect,
    ModelTags
  },
  mixins: [
    searchStateMixin,
    tagsMixin
  ],
  props: {
    columns: Array
  },
  data() {
    return {
      title_desc: null,
      area_id: null,
      tags: null,
      match: 'any',
      schedFilter: 'all',
      tag: null,
      label: null
    }
  },
  watch: {
    schedFilter(newVal, oldVal) {
      if (newVal != oldVal) {
        this.onSearch()
      }
    }
  },
  computed: {
    sessionTagsDropDownOptions() {
      this.sessionTagsOptions.unshift(
        {
          value: null,
          text: "Any Tag"
        }
      )
      return this.sessionTagsOptions
    },
    sessionLabelsDropDownOptions() {
      this.sessionLabelsOptions.unshift(
        {
          value: null,
          text: "Any Label"
        }
      )
      return this.sessionLabelsOptions
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

      if (this.tag) {
        queries["queries"].push(
          ["tags_list_table.tags_array","is",this.tag],
        )
      }

      if (this.label) {
        queries["queries"].push(
          ["labels_list_table.labels_array", "is", this.label],
        )
      }

      if (this.schedFilter != 'all') {
        if (this.schedFilter == 'time') {
          queries = {
            "op": 'all',
            "queries": [
              ["start_time","is not null",null],
              ["room_id", "is null"],
              queries
            ]
          }
        } else {
          queries = {
            "op": 'all',
            "queries": [
              ["start_time","is null"],
              ["room_id", "is not null"],
              queries
            ]
          }
        }
      } else {
        queries = {
          "op": 'all',
          "queries": [
            {
              "op": "any",
              "queries":[
                ["start_time", "is null"],
                ["room_id", "is null"]
              ]
            },
            queries
          ]
        }
      }
      return queries
    },
    onSearch: function (event) {
      this.setSearchState({
        key: SAVED_SEARCH_STATE,
        setting: {
          title_desc: this.title_desc,
          area_id: this.area_id,
          tag: this.tag,
          label: this.label,
          match: this.match,
          schedFilter: this.schedFilter
        }
      })
      this.$emit('change', this.fields_to_query())
    },
    init() {
      let saved = this.getSearchState()(SAVED_SEARCH_STATE)
      if (saved) {
        this.title_desc = saved.title_desc
        this.area_id = saved.area_id
        this.tag = saved.tag
        this.label = saved.label
        this.match = saved.match
        this.schedFilter = saved.schedFilter
      }

      this.$emit('change', this.fields_to_query())
    }
  },
  mounted() {
    this.init();
  }
}
</script>

<style lang="scss" scoped>
</style>
