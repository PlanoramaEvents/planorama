<template>
  <div class="container">
    <b-row align-v="center">
      <b-col cols="2">
        <b-form-group label="Obszar">
          <model-select
            v-model="area_id"
            model="area"
            field="name"
            unselected-display="Dowolny obszar"
          ></model-select>
        </b-form-group>
      </b-col>
      <b-col cols="2">
        <b-form-group label="Tag">
          <model-tags
            v-model="tags"
            model="tag"
            field="name"
            filter='{"op":"all","queries":[["taggings.taggable_type", "=", "Session"], ["taggings.context", "=", "tags"]]}'
            :formatter="tagFormatter"
          ></model-tags>
        </b-form-group>
      </b-col>
      <b-col cols="4">
        <b-form-group label="Tytuł lub opis">
          <b-form-input
            type="text"
            v-model="title_desc"
          ></b-form-input>
        </b-form-group>
      </b-col>
      <b-col cols="2 align-self-end">
        <b-form-group>
          <b-form-radio v-model="match" name="search-match" value="any">Dopasuj dowolne</b-form-radio>
          <b-form-radio v-model="match" name="search-match" value="all">Dopasuj wszystkie</b-form-radio>
        </b-form-group>
      </b-col>
      <b-col cols="2 align-self-end">
        <b-button variant="primary" @click="onSearch" class="search-button">Szukaj</b-button>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { tagFormatter } from '@/store/tags.mixin';
import ModelSelect from '../components/model_select';
import ModelTags from '../components/model_tags';
import searchStateMixin from '../store/search_state.mixin'
import { personSessionMixin } from '@/mixins';

const SAVED_SEARCH_STATE = "SESSION SELECT STATE";

export default {
  name: 'SessionSearch',
  components: {
    ModelSelect,
    ModelTags
  },
  mixins: [
    searchStateMixin,
    personSessionMixin
  ],
  props: {
    columns: Array,
    personId: String
  },
  data() {
    return {
      title_desc: null,
      area_id: null,
      tags: null,
      match: 'any',
      tagFormatter
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
              ["description","contains",this.title_desc]
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
        let vals = this.tags.map(obj => (obj.value))
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
      // Only deal wuth the saved filter the current user is the person we are looking at
      if (this.currentUser.id == this.personId) {
        let saved = this.getSearchState()(SAVED_SEARCH_STATE)
        if (saved) {
          this.title_desc = saved.title_desc
          this.area_id = saved.area_id
          this.tags = saved.tags
          this.match = saved.match
          this.$emit('change', this.fields_to_query())
        }
      }
    }
  },
  mounted() {
    this.init();
  }
}
</script>

<style lang="scss" scoped>
.search-button {
  margin-bottom: 1em;
}
</style>
