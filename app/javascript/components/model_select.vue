<template>
  <b-overlay :show="loading" rounded="sm">
    <b-form-select
      v-model="value"
      @change="onChange"
      v-bind:options="options"
      class="mt-1"
      :disabled='disabled'
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
      this.search({
        fields: field_name,
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
