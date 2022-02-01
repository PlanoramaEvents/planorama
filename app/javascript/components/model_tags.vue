<template>
  <b-overlay :show="loading" rounded="sm">
    <v-select
      v-model="value"
      @change="onChange"
      v-bind:options="options"
      :disabled='disabled'
      multiple
    ></v-select>
  </b-overlay>
</template>

<!-- See: https://vue-select.org/ -->

<script>
import modelMixin from '../store/model.mixin';
import vSelect from 'vue-select'

export default {
  name: 'ModelTags',
  components: {
    vSelect
  },
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
      // I just want the "ids"
      this.$emit('input', n)
    },
    data(newVal,o) {
      if (newVal) {
        this.options = Object.values(newVal).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
            {
              code: obj.id,
              label: obj[this.field]
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
