<template>
  <div>
    <b-input-group>
      <b-form-input
        type="text"
        v-model="term"
        debounce="500"
      ></b-form-input>
    </b-input-group>

    <b-form-select
      v-model="selectedOption"
      v-bind:options="filtered_options"
      v-bind:select-size="selectSize"
    ></b-form-select>
  </div>
</template>

<script>

export default {
  name: 'ComboBox',
  props: {
    selectSize: Number,
    options: Array
  },
  data: () =>  ({
    selectedOption: null,
    term: null
  }),
  computed: {
    filtered_options() {
      return this.options.filter(
        obj => ((this.term == null) || (this.term === "") || obj.text.toLowerCase().includes(this.term.toLowerCase()))
      )
    }
  }
}
</script>
