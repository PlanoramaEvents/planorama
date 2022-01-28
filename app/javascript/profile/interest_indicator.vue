<template>
  <b-form-checkbox
    switch size="lg"
    v-model="interested"
    @change="toggleSelectSession"
  >
  </b-form-checkbox>
</template>

<script>
export default {
  name: "InterestIndicator",
  mixins: [
    // modelMixin,
  ],
  props: {
    value: {
      type: Object,
      default: null
    }
    // assignment: {
    //   type: Object,
    //   default: null
    // },
  },
  data: () => ({
    interested: { },
  }),
  watch: {
    value(newVal, oldVal) {
      console.debug("***** VAL IS: ", newVal, this.value)
      // if (newVal) {
      // create
      //   this.assignment = {}
      // } else {
      // delete
      //   this.assignment = null
      // }
    }
  },
  methods: {
    toggleSelectSession(arg) {
      // arg is the id of the selected item
      console.debug('Toggle select this: ', arg)
    }
  },
  mounted() {
    // console.debug('MOUNT SELECTOR', this.value.id)
    this.interested = typeof this.value.id !== 'undefined' //this.value.id == null
  }
}
</script>

<style>

</style>
