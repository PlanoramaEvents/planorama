<template>
  <div>
    <b-input-group>
      <b-form-input
        type="text"
        v-model="term"
        debounce="500"
      ></b-form-input>
    </b-input-group>

    <b-overlay :show="loading" rounded="sm">
      <b-form-select
        v-model="selectedOption"
        @change="onChange"
        :options="filtered_options"
        :select-size="selectSize"
        class="mt-1"
      ></b-form-select>
    </b-overlay>
  </div>
</template>

<script>

export default {
  name: 'ComboBox',
  props: {
    selectSize: Number,
    options: Array,
    loading: {
      type: Boolean,
      default: false
    },
    value: {}
  },
  data: () =>  ({
    selectedOptionInternal: null,
    term: null
  }),
  methods: {
    onChange(arg) {
      this.$emit('change', arg);
    }
  },
  computed: {
    selectedOption: {
      get() {
        return this.value ?? this.selectedOptionInternal;
      }, 
      set(val) {
        this.selectedOptionInternal = val;
        this.$emit('input', val);
      }

    },
    filtered_options() {
      return this.options.filter(
        obj => ((this.term == null) || (this.term === "") || obj.text.toLowerCase().includes(this.term.toLowerCase()))
      )
    }
  }
}
</script>
