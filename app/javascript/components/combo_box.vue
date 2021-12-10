<template>
  <div>
    <b-input-group>
      <b-input-group-text>
        <b-icon icon="search" />
      </b-input-group-text>
      <b-form-input
        type="text"
        v-model="term"
        debounce="500"
      ></b-form-input>
    </b-input-group>

    <b-form-select
      v-model="selectedOption"
      :options="options"
      v-bind:select-size="selectSize"
    ></b-form-select>
  </div>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import modelMixin from '../store/model.mixin';

export default {
  name: 'ComboBox',
  props: {
    attribute: String,
    selectSize: Number
  },
  mixins: [
    modelMixin,
    toastMixin
  ],
  data: () =>  ({
    selectedOption: null,
    options: [],
    data: [],
    term: null
  }),
  methods: {
    init() {
      // TODO: optimize by putting in field filter
      this.search({}).then(data => {this.data = data})
    }
  },
  watch: {
    selectedOption(newVal, oldVal) {
      if (newVal != oldVal) {
        // TODO: emit event with the select id (or object)
        console.debug("**** selected:", newVal)
      }
    },
    term(newVal, oldVal) {
      if (newVal != oldVal) {
        // TODO: filter options based on search term
        console.debug("**** search:", newVal)
        this.options = Object.values(this.data).filter(
          obj => (typeof obj.json === 'undefined')
        ).filter(
          obj => (obj[this.attribute] == newVal)
        ).map(
          obj => (
            {
              value: obj.id,
              text: obj[this.attribute]
            }
          )
        )
      }
    },
    data(newVal, oldVal) {
      if (newVal) {
        this.options = Object.values(newVal).filter(
          obj => (typeof obj.json === 'undefined')
        ).map(
          obj => (
            {
              value: obj.id,
              text: obj[this.attribute]
            }
          )
        )
      } else {
        this.options = []
      }
    }
  },
  mounted() {
    this.init()
  }
}
</script>
