<template>
  <b-overlay :show="loading" rounded="sm">
    <b-form-select
      v-model="value"
      @change="onChange"
      v-bind:options="options"
      :disabled='disabled'
      :multiple="multiple"
    ></b-form-select>
  </b-overlay>
</template>

<script>
import modelMixin from '../store/model.mixin';

export default {
  name: 'ModelSelect',
  props: {
    // TODO: value is prop is a problem?
    value: null,
    field: null,
    unselectedDisplay: null,
    multiple: false,
    disabled: {
      type: Boolean,
      default: false
    }
  },
  mixins: [
    modelMixin
  ],
  data: () =>  ({
    term: null,
    options: [],
    loading: false,
    data: null
  }),
  watch: {
    value(n,o) {
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
        "sortOrder": 'asc'
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
    this.init()
  }
}
</script>
