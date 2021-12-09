<template>
  <div>
    <b-form-select
      v-model="theone"
      :options="options"
      :select-size="4"
    ></b-form-select>
  </div>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
import modelMixin from '../store/model.mixin';
// TODO: change
import { personModel as model } from '../store/person.store';

export default {
  name: "MailingsManager",
  components: {
    // ModelField,
    // EmailField,
  },
  mixins: [
    modelMixin,
    toastMixin
  ],
  data: () =>  ({
    // model,
    theone: null,
    options: []
  }),
  props: {
    // showButtons: {
    //   default: true,
    //   tyep: Boolean
    // }
  },
  computed: {
  },
  methods: {
    init() {
      this.search({})
        .then(data => {
          console.debug("**** THE DATA IS", data)
          this.options = [
            { value: null, text: 'Please select some item' },
            { value: 'a', text: 'This is option a' },
            { value: 'b', text: 'Default Selected Option b' },
            { value: 'c', text: 'This is option c' },
            { value: 'd', text: 'This one is disabled', disabled: true },
            { value: 'e', text: 'This is option e' },
            { value: 'e', text: 'This is option f' }
          ]
        })
    }
    // TODO: need edit/select?
  },
  mounted() {
    this.init()
  }
}
</script>

<style>

</style>
