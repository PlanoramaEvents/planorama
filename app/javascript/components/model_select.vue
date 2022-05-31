<template>
  <b-overlay :show="loading" rounded="sm">
    <b-form-select
      v-model="selectedValue"
      @change="onChange"
      :options="options"
      :disabled="disabled"
      :multiple="multiple"
      :size="size"
      :select-size="selectSize"
    ></b-form-select>
  </b-overlay>
</template>

<script>
import modelMixin from '../store/model.mixin';

export default {
  name: 'ModelSelect',
  props: {
    value: null,
    field: null,
    unselectedDisplay: null,
    multiple: false,
    disabled: {
      type: Boolean,
      default: false
    },
    size: {
      type: String
    },
    filter: null,
    selectSize: {
      default: 0
    }
  },
  mixins: [
    modelMixin
  ],
  data: () =>  ({
    term: null,
    options: [],
    loading: false,
    data: null,
    selectedVals: []
  }),
  computed: {
    selectedValue: {
      get() {
        return this.selectedVals
      },
      set(v) {
        this.selectedVals = v
      }
    }
  },
  watch: {
    value(n,o) {
      this.selectedVals = n
    },
    selectedValue(n,o) {
      this.$emit('input', n)
    },
    data(newVal,o) {
      if (newVal) {
        this.options = Object.values(newVal).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
            {
              value: obj.id,
              text: obj[this.field]
            }
          )
        )
      } else {
        this.options = []
      }

      if (this.unselectedDisplay) {
        this.options.unshift(
          {
           value: null,
           text: this.unselectedDisplay
          }
        )
      }
    }
  },
  methods: {
    onChange(arg) {
      this.$emit('change', arg)
    },
    initialize() {
      this.loading = true
      let fields = `fields[${this.model}]`
      let field_name = `id,${this.field}`
      let models = this.$pluralize(this.model)
      let sort_by = `${models}.${this.field}`
      this.search({
        fields: field_name,
        "sortBy": sort_by,
        "sortOrder": 'asc',
        "filter": this.filter
      }).then(data => {
        this.data = data
        this.loading = false
      })
    },
    init() {
      this.initialize()
    }
  },
  mounted() {
    this.selectedVals = this.value
    this.init()
  }
}
</script>
